import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(Uint8List imageBytes) async {
  try {
    // Genera un nombre de archivo único para la imagen
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Crea una referencia a Firebase Storage
    Reference ref = storage.ref().child('uploads/$fileName.jpg');

    // Sube la imagen a Firebase Storage
    UploadTask uploadTask = ref.putData(imageBytes);

    // Espera a que la carga se complete
    TaskSnapshot snapshot = await uploadTask;

    // Verifica si la carga fue exitosa
    if (snapshot.state == TaskState.success) {
      print('Imagen subida correctamente');
      return true;
    } else {
      print('Error al subir la imagen');
      return false;
    }
  } catch (e) {
    print('Error al subir la imagen: $e');
    return false;
  }
}
