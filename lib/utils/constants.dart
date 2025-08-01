// App Constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'Grape Leaf Disease Detector';
  static const String appVersion = '1.0.0';

  // Model Configuration
  static const String modelPath = 'assets/model.tflite';
  static const String labelsPath = 'assets/labels.txt';

  // Model Input Configuration
  static const int imageWidth = 224;
  static const int imageHeight = 224;
  static const int imageChannels = 3;

  // Default Labels
  static const List<String> defaultLabels = ['Healthy', 'Diseased'];

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double cardElevation = 4.0;

  // Analysis Messages
  static const String selectImageMessage = "Press a button to select an image.";
  static const String analyzingMessage = "Analyzing image...";
  static const String modelNotLoadedMessage = "Model not loaded.";
  static const String labelsNotLoadedMessage = "Labels not loaded.";
  static const String imageDecodeErrorMessage = "Failed to decode image.";
  static const String inferenceErrorMessage =
      "Error during inference. Check model compatibility.";

  // Info Text
  static const String infoText =
      "Select an image from your gallery or take a photo to analyze grape leaf health using AI.";
}
