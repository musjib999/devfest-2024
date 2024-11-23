import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MediaService {
  Future<XFile?> pickImage({ImageSource? source}) async {
    ImagePicker picker = ImagePicker();
    XFile? result = await picker.pickImage(
      source: source ?? ImageSource.camera,
      imageQuality: 30,
    );

    if (result != null) {
      final fileSize = await File(result.path).length();

      if (fileSize < 2 * 1024 * 1024) {
        return result;
      } else {
        throw 'The selected image exceeds 2 MB select an image less than 2 MB';
      }
    } else {
      return null;
    }
  }
}
