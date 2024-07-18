import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    return await image.readAsBytes();
  }
  return null;
}