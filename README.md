# TFLite Grapes - Grape Disease Classification App

This Flutter application leverages a powerful TensorFlow Lite (TFLite) model to classify grape leaf diseases. The app allows users to capture or select an image of a grape leaf, and the model will predict whether the leaf is healthy or diseased, providing a confidence score for the prediction.

## Features

- **Image-based Disease Classification**: Analyze images of grape leaves to detect signs of disease.
- **Real-time Predictions**: Get instant classification results using a highly optimized TFLite model.
- **Cross-Platform**: Built with Flutter for a seamless experience on both Android and iOS.
- **User-Friendly Interface**: A simple and intuitive UI for easy image selection and analysis.
- **Light & Dark Themes**: Includes support for both light and dark modes for user comfort.

## The TFLite Model (by Berkay)

The core of this application is the sophisticated TFLite model developed by **[Berkay](https://github.com/berkayozdmr21)**. This model has been meticulously trained to distinguish between healthy and diseased grape leaves with high accuracy.

### Model Architecture and Training

The model is a deep learning neural network, likely a Convolutional Neural Network (CNN), which is the standard for image classification tasks. Here's a conceptual overview of how it was likely built:

1.  **Dataset Collection**: The model was trained on a large dataset of grape leaf images, carefully labeled as "healthy" or "diseased." The quality and diversity of this dataset are crucial for the model's accuracy.

2.  **Data Preprocessing**: Before training, the images undergo several preprocessing steps:
    *   **Resizing**: Images are resized to a uniform dimension that matches the model's input layer (e.g., 224x224 pixels).
    *   **Normalization**: Pixel values are normalized to a specific range (e.g., [0, 1] or [-1, 1]) to stabilize the training process.
    *   **Data Augmentation**: To improve the model's ability to generalize, the training data is often augmented with random transformations like rotations, flips, and zooms.

3.  **Model Architecture**: The CNN architecture consists of multiple layers:
    *   **Convolutional Layers**: These layers apply filters to the input image to extract features like edges, textures, and shapes.
    *   **Pooling Layers**: These layers down-sample the feature maps, reducing the computational load and helping the model to become more robust to variations in the position of features.
    *   **Dense (Fully Connected) Layers**: These layers perform the final classification based on the extracted features.

4.  **Training**: The model is trained using an optimization algorithm (like Adam) that adjusts the model's weights to minimize the difference between its predictions and the actual labels in the training data.

5.  **Conversion to TFLite**: After training, the model is converted to the TensorFlow Lite (`.tflite`) format. This process optimizes the model for deployment on mobile and embedded devices by:
    *   **Quantization**: Reducing the precision of the model's weights (e.g., from 32-bit floats to 8-bit integers) to decrease the model size and speed up inference, often with minimal impact on accuracy.
    *   **Pruning**: Removing unnecessary connections in the neural network to further reduce size and latency.

### Model Integration in the App

The `ml_service.dart` file in this project is responsible for loading the `.tflite` model and running inference. When a user selects an image, the app performs the following steps, mirroring the preprocessing done during the model's training:

1.  **Image Loading**: The selected image is loaded into memory.
2.  **Resizing and Normalization**: The image is resized to the model's expected input dimensions, and its pixel values are normalized.
3.  **Inference**: The processed image data is fed into the TFLite interpreter, which runs the model and produces an output tensor.
4.  **Post-processing**: The output tensor, which contains the probabilities for each class ("healthy" and "diseased"), is processed to identify the class with the highest probability. This result is then displayed to the user.

Berkay's work on this TFLite model is the cornerstone of the app's functionality, enabling accurate and efficient disease classification directly on the user's device.

## Flutter Application

The Flutter side of the project, developed by you, provides the user interface and handles the interaction with the TFLite model.

### Key Components

-   **`main.dart`**: The entry point of the application, responsible for setting up the app and its themes.
-   **`home_screen.dart`**: The main UI of the app, which allows users to pick images and view the prediction results.
-   **`ml_service.dart`**: A service that encapsulates all the logic for interacting with the TFLite model.
-   **`prediction_card.dart`**: A widget for displaying the prediction results in a clean and readable format.
-   **`app_theme.dart` & `constants.dart`**: Files for managing the app's visual theme and constant values.

## How to Run the Project

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/tflite_grapes.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## Acknowledgements

-   **[Berkay](https://github.com/berkayozdmr21)**: For developing and training the advanced TFLite model that powers this application.
-   **You**: For building the Flutter application and integrating the model.
