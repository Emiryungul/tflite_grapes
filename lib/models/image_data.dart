import 'dart:io';

class ImageData {
  final File file;
  final String name;
  final DateTime selectedAt;

  ImageData({required this.file, required this.name, required this.selectedAt});

  factory ImageData.fromFile(File file) {
    return ImageData(
      file: file,
      name: file.path.split('/').last,
      selectedAt: DateTime.now(),
    );
  }
}
