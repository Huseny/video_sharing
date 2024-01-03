import 'dart:io';

import 'package:file_picker/file_picker.dart';

class PickFiles {
  Future<File?> pickFile(FileType fileType, bool allowMutliple,
      {List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMutliple,
    );

    if (result != null && result.files.isNotEmpty) {
      final path = result.files.first.path;
      if (path != null) {
        return File(path);
      }
    }
    return null;
  }
}