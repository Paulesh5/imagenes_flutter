import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imagenes_flutter/services/select_image.dart';
import 'services/upload_image.dart';
import 'dart:js' as js;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? imagen_to_upload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 600, // Max width for the container
            maxHeight: double.infinity, // Allow the container to grow in height
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the image if available
              Expanded(
                child: imagen_to_upload != null
                    ? SingleChildScrollView(
                        child: Container(
                          constraints: BoxConstraints(
                            maxHeight: 300, // Max height for the image
                            maxWidth: double.infinity, // Max width for the image
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.memory(imagen_to_upload!),
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.all(10),
                        height: 200,
                        width: double.infinity,
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            'Vista previa de la imagen',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
              ),
              // Space between image preview and buttons
              SizedBox(height: 20),
              // Buttons
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final bytes = await getImage();
                          setState(() {
                            imagen_to_upload = bytes;
                          });
                        } catch (e) {
                          print('Error selecting image: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al seleccionar imagen: $e')),
                          );
                        }
                      },
                      child: const Text("Seleccionar imagen"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Call the function to start the camera stream
                        try {
                          js.context.callMethod('getCameraStream');
                        } catch (e) {
                          print('Error accessing camera: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al acceder a la cámara: $e')),
                          );
                          return;
                        }

                        // Delay to allow the camera preview to initialize
                        await Future.delayed(Duration(seconds: 1));

                        try {
                          final dataUrl = js.context.callMethod('captureImage') as String;
                          final bytes = await _dataUrlToUint8List(dataUrl);
                          setState(() {
                            imagen_to_upload = bytes;
                          });
                        } catch (e) {
                          print('Error capturing image: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al capturar imagen: $e')),
                          );
                        }
                      },
                      child: const Text("Tomar imagen"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (imagen_to_upload == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No hay imagen para subir')),
                          );
                          return;
                        }
                        try {
                          final uploaded = await uploadImage(imagen_to_upload!);
                          if (uploaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Imagen subida correctamente')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al subir la imagen')),
                            );
                          }
                        } catch (e) {
                          print('Error uploading image: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al subir la imagen: $e')),
                          );
                        }
                      },
                      child: const Text("Subir a Firebase"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _dataUrlToUint8List(String dataUrl) async {
    try {
      final response = await http.get(Uri.parse(dataUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image from data URL');
      }
    } catch (e) {
      print('Error converting data URL to Uint8List: $e');
      throw e;
    }
  }
}
