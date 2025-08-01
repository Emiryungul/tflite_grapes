import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/ml_service.dart';
import '../../utils/constants.dart';
import '../../widgets/prediction_card.dart';

class HomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  String _prediction = AppConstants.selectImageMessage;
  final ImagePicker _picker = ImagePicker();
  final MLService _mlService = MLService();
  bool _isModelLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMLService();
  }

  Future<void> _initializeMLService() async {
    try {
      await _mlService.initialize();
      setState(() {
        _isModelLoading = false;
      });
    } catch (e) {
      setState(() {
        _isModelLoading = false;
        _prediction = "Failed to load model: $e";
      });
    }
  }

  Future<void> _runInference(File imageFile) async {
    if (!_mlService.isModelLoaded) {
      setState(() {
        _prediction = AppConstants.modelNotLoadedMessage;
      });
      return;
    }

    try {
      final result = await _mlService.predict(imageFile);
      setState(() {
        _prediction = result.formattedResult;
      });
    } catch (e) {
      setState(() {
        _prediction = "Error: $e";
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _prediction = AppConstants.analyzingMessage;
      });
      await _runInference(File(pickedFile.path));
    }
  }

  @override
  void dispose() {
    _mlService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // Theme switcher button
          PopupMenuButton<ThemeMode>(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : widget.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.brightness_auto,
            ),
            onSelected: widget.onThemeChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Row(
                  children: [
                    Icon(
                      Icons.brightness_auto,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    const Text('System'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Row(
                  children: [
                    Icon(
                      Icons.light_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    const Text('Light'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Row(
                  children: [
                    Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    const Text('Dark'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image Display Card
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: _image != null
                    ? Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                              ),
                              child: Image.file(_image!, fit: BoxFit.contain),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Selected Image",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 80,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No image selected.",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Prediction Results Card
            PredictionCard(prediction: _prediction),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FilledButton.icon(
                      onPressed: _isModelLoading
                          ? null
                          : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text("Gallery"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FilledButton.tonalIcon(
                      onPressed: _isModelLoading
                          ? null
                          : () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Info Card
            Card(
              color: Theme.of(context).colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppConstants.infoText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
