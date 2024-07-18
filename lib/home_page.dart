import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:imagenes_flutter/services/select_image.dart';
import 'services/upload_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? imagen_to_upload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Column(
        children: [
          imagen_to_upload != null ? Image.memory(imagen_to_upload!) :
          Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            width: double.infinity,
            color: Colors.red,
          ),
          ElevatedButton(
            onPressed: () async {
              final bytes = await getImage();
              setState(() {
                imagen_to_upload = bytes;
              });
            }, child: const Text("Seleccionar imagen")),
          ElevatedButton(
            onPressed: () async {
              if (imagen_to_upload == null) {
                return;
              }
              final uploaded = await uploadImage(imagen_to_upload!);
              if (uploaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Imagen subida correctamente'))
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al subir la imagen'))
                );
              }
            }, child: const Text("Subir a Firebase"))
        ],
      ),
    );
  }
}
