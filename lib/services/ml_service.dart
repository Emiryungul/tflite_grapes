import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image/image.dart' as img;
import '../utils/constants.dart';

class MLService {
  static final MLService _instance = MLService._internal();
  factory MLService() => _instance;
  MLService._internal();

  tfl.Interpreter? _interpreter;
  List<String> _labels = AppConstants.defaultLabels;

  // Getters
  bool get isModelLoaded => _interpreter != null;
  List<String> get labels => _labels;

  /// Initialize the ML service and load the model
  Future<void> initialize() async {
    await _loadModel();
  }

  /// Load the TFLite model
  Future<void> _loadModel() async {
    try {
      print('Attempting to load model from assets...');

      // Try loading as ByteData first
      final ByteData modelData = await rootBundle.load(AppConstants.modelPath);
      final Uint8List modelBytes = modelData.buffer.asUint8List();
      print('Model data loaded, size: ${modelBytes.length} bytes');

      // Prepare interpreter options
      final options = tfl.InterpreterOptions();

      // Add Metal GPU delegate for iOS if available
      if (Platform.isIOS) {
        try {
          final gpuDelegate = tfl.GpuDelegate(
            options: tfl.GpuDelegateOptions(
              allowPrecisionLoss: false,
              enableQuantization: true,
            ),
          );
          options.addDelegate(gpuDelegate);
          print('✅ Metal GPU delegate added for iOS.');
        } catch (e) {
          print('⚠️ Failed to load GPU delegate for iOS: $e. Using CPU.');
        }
      }

      _interpreter = await tfl.Interpreter.fromBuffer(
        modelBytes,
        options: options,
      );
      print('Model loaded successfully from buffer');
      print('Input shape: ${_interpreter!.getInputTensor(0).shape}');
      print('Input type: ${_interpreter!.getInputTensor(0).type}');
      print('Output shape: ${_interpreter!.getOutputTensor(0).shape}');
      print('Output type: ${_interpreter!.getOutputTensor(0).type}');
    } catch (e) {
      print('Failed to load model: $e');
      print('Error type: ${e.runtimeType}');

      // Fallback: try the original fromAsset method
      try {
        print('Trying fallback method...');
        _interpreter = await tfl.Interpreter.fromAsset('model.tflite');
        print('Model loaded successfully with fallback method');
      } catch (e2) {
        print('Fallback also failed: $e2');
        rethrow;
      }
    }
  }

  /// Run inference on the provided image (EXACT COLAB MATCH)
  Future<PredictionResult> predict(File imageFile) async {
    if (_interpreter == null) {
      throw Exception(AppConstants.modelNotLoadedMessage);
    }

    if (_labels.isEmpty) {
      throw Exception(AppConstants.labelsNotLoadedMessage);
    }

    // 1. Decode image
    final imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception(AppConstants.imageDecodeErrorMessage);
    }

    // 2. Get input shape (like Colab)
    var inputShape = _interpreter!.getInputTensor(0).shape;
    print("Input shape: $inputShape");

    // 3. Calculate image size based on input shape (EXACT COLAB LOGIC)
    late int imageWidth, imageHeight;

    if (inputShape.length == 2 && inputShape[1] % 3 == 0) {
      // Flattened input [1, W*H*C]
      int pixelsPerImage = (inputShape[1] / 3).round();
      int imageDimension = math.sqrt(pixelsPerImage).round();
      imageWidth = imageDimension;
      imageHeight = imageDimension;
      print(
        "Flattened input detected, calculated size: ${imageWidth}x${imageHeight}",
      );
    } else if (inputShape.length == 4) {
      // 4D input [1, H, W, C] - PIL resize takes (width, height)
      imageWidth = inputShape[2];
      imageHeight = inputShape[1];
      print("4D input detected, size: ${imageWidth}x${imageHeight}");
    } else {
      throw Exception("Unexpected input shape: $inputShape");
    }

    // 4. Resize image to calculated size (like Colab)
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: imageWidth,
      height: imageHeight,
    );

    // 5. Convert to Float32List and normalize to [0, 1] (EXACT COLAB: / 255.0)
    var imgArray = Float32List(imageHeight * imageWidth * 3);
    int index = 0;

    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        imgArray[index++] = pixel.r.toDouble() / 255.0;
        imgArray[index++] = pixel.g.toDouble() / 255.0;
        imgArray[index++] = pixel.b.toDouble() / 255.0;
      }
    }

    // 6. Reshape based on input shape (EXACT COLAB LOGIC)
    var input;
    if (inputShape.length == 2) {
      // Flatten for [1, W*H*C]
      input = imgArray.reshape([1, inputShape[1]]);
    } else if (inputShape.length == 4) {
      // Reshape to [1, H, W, C]
      input = imgArray.reshape([1, imageHeight, imageWidth, 3]);
    } else {
      throw Exception("Reshaping error for input shape: $inputShape");
    }

    // 7. Create output tensor
    var outputShape = _interpreter!.getOutputTensor(0).shape;
    var output = List.generate(
      outputShape.fold(1, (a, b) => a * b),
      (index) => 0.0,
    ).reshape(outputShape);

    // 8. Run inference
    try {
      _interpreter!.run(input, output);
    } catch (e) {
      print("Error running model inference: $e");
      throw Exception(AppConstants.inferenceErrorMessage);
    }

    // 9. Get prediction using argmax (EXACT COLAB: np.argmax)
    print("Raw output: $output");

    var outputData = output[0] as List<double>;
    int prediction = 0;
    double maxValue = outputData[0];

    for (int i = 1; i < outputData.length; i++) {
      if (outputData[i] > maxValue) {
        maxValue = outputData[i];
        prediction = i;
      }
    }

    // 10. Map to class labels (like Colab)
    String predictedClass = _labels[prediction];
    print("✅ Prediction: $predictedClass (index: $prediction)");

    return PredictionResult(
      className: predictedClass,
      confidence: maxValue,
      healthyProbability: outputData.length > 0 ? outputData[0] : 0.0,
      diseasedProbability: outputData.length > 1 ? outputData[1] : 0.0,
    );
  }

  /// Dispose resources
  void dispose() {
    _interpreter?.close();
  }
}

/// Data class for prediction results
class PredictionResult {
  final String className;
  final double confidence;
  final double healthyProbability;
  final double diseasedProbability;

  PredictionResult({
    required this.className,
    required this.confidence,
    required this.healthyProbability,
    required this.diseasedProbability,
  });

  String get formattedResult =>
      "Prediction: $className (${(confidence * 100).toStringAsFixed(1)}% confidence)";
}
