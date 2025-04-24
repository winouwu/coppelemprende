import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:developer' as developer;

class INEScannerScreen extends StatefulWidget {
  final Function(Map<String, String>) onINEDataExtracted;

  const INEScannerScreen({
    Key? key,
    required this.onINEDataExtracted,
  }) : super(key: key);

  @override
  State<INEScannerScreen> createState() => _INEScannerScreenState();
}

class _INEScannerScreenState extends State<INEScannerScreen> {
  File? _image;
  bool _isProcessing = false;
  final picker = ImagePicker();
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    // Abrir la cámara automáticamente al entrar a la pantalla
    _getImage(ImageSource.camera);
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _processImage();
      } else {
        // Si el usuario cancela, volver a la pantalla anterior
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      developer.log('Error al obtener imagen: $e', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al acceder a la cámara: $e')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() => _isProcessing = true);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String extractedText = '';
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          extractedText += '${line.text}\n';
        }
      }

      developer.log('TEXTO EXTRAÍDO DE LA IMAGEN:');
      developer.log(extractedText);

      Map<String, String> ineData = _processINEText(extractedText);
      
      developer.log('DATOS PROCESADOS:');
      ineData.forEach((key, value) => developer.log('$key: $value'));
      
      setState(() => _isProcessing = false);

      // Llamar a la función de callback con los datos extraídos
      widget.onINEDataExtracted(ineData);
      
      // Volver a la pantalla anterior
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      developer.log('Error al procesar imagen: $e', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar imagen: $e')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Map<String, String> _processINEText(String rawText) {
    // Expresiones regulares para extraer la información
    RegExp nombreCompletoRegExp = RegExp(r'NOMBRE\s+([A-ZÁÉÍÓÚÑ]+)\s+([A-ZÁÉÍÓÚÑ]+)\s+([A-ZÁÉÍÓÚÑ]+)', caseSensitive: true);
    RegExp domicilioRegExp = RegExp(r'DOMICILIO\s+(.*?)(?:COL|CIUDAD|C\.P\.|ALCALDIA)', caseSensitive: false);
    RegExp cpostalRegExp = RegExp(r'C\.P\.\s*(\d{5})', caseSensitive: false);
    
    // Intento más flexible para nombres:
    RegExp nombreFlexibleRegExp = RegExp(r'(?:NOMBRE|NOMBRES?)[:\s]*([A-ZÁÉÍÓÚÑ]+(?:\s+[A-ZÁÉÍÓÚÑ]+){1,3})', caseSensitive: false);
    
    // Buscar nombres en mayúsculas (3 palabras) que pueden ser apellidos y nombre
    RegExp soloNombreRegExp = RegExp(r'([A-ZÁÉÍÓÚÑ]{3,})\s+([A-ZÁÉÍÓÚÑ]{3,})\s+([A-ZÁÉÍÓÚÑ]{3,})', caseSensitive: true);
    
    // Buscar códigos postales (5 dígitos)
    RegExp cpSimpleRegExp = RegExp(r'(\b\d{5}\b)', caseSensitive: false);

    String nombreCompleto = '';
    String nombre = '';
    String apellido1 = '';
    String apellido2 = '';
    String codigoPostal = '';

    // Intentar extraer el nombre completo
    final nombreMatch = nombreCompletoRegExp.firstMatch(rawText);
    if (nombreMatch != null && nombreMatch.groupCount >= 3) {
      apellido1 = nombreMatch.group(1) ?? '';
      apellido2 = nombreMatch.group(2) ?? '';
      nombre = nombreMatch.group(3) ?? '';
      nombreCompleto = '$nombre $apellido1 $apellido2'; // Formato natural de nombre
    } else {
      // Intentar extraer con el patrón flexible
      final nombreFlexibleMatch = nombreFlexibleRegExp.firstMatch(rawText);
      if (nombreFlexibleMatch != null && nombreFlexibleMatch.group(1) != null) {
        nombreCompleto = nombreFlexibleMatch.group(1)!;
        
        // Intentar separar en apellidos y nombre
        final parts = nombreCompleto.split(' ');
        if (parts.length >= 3) {
          // Asumiendo formato: APELLIDO1 APELLIDO2 NOMBRE(S)
          apellido1 = parts[0];
          apellido2 = parts[1];
          nombre = parts.sublist(2).join(' ');
        } else if (parts.length == 2) {
          // Asumiendo formato: APELLIDO1 NOMBRE
          apellido1 = parts[0];
          nombre = parts[1];
        } else {
          nombre = nombreCompleto;
        }
      } else {
        // Último intento con expresión regular simple
        final soloNombreMatch = soloNombreRegExp.firstMatch(rawText);
        if (soloNombreMatch != null) {
          apellido1 = soloNombreMatch.group(1) ?? '';
          apellido2 = soloNombreMatch.group(2) ?? '';
          nombre = soloNombreMatch.group(3) ?? '';
          nombreCompleto = '$nombre $apellido1 $apellido2';
        }
      }
    }

    // Extraer código postal
    final cpMatch = cpostalRegExp.firstMatch(rawText);
    if (cpMatch != null && cpMatch.group(1) != null) {
      codigoPostal = cpMatch.group(1) ?? '';
    } else {
      // Si no se encontró, buscar cualquier secuencia de 5 dígitos
      final cpSimpleMatch = cpSimpleRegExp.firstMatch(rawText);
      if (cpSimpleMatch != null) {
        codigoPostal = cpSimpleMatch.group(1) ?? '';
      }
    }

    return {
      'nombre': nombre,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'nombreCompleto': nombreCompleto,
      'codigoPostal': codigoPostal,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear INE'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: _isProcessing
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Procesando INE, por favor espere...'),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_image != null)
                    Expanded(
                      child: Image.file(_image!, fit: BoxFit.contain),
                    )
                  else
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 100, color: Colors.grey),
                          SizedBox(height: 20),
                          Text('Apunte a la INE para escanear'),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _getImage(ImageSource.camera),
                          child: Text('Tomar otra foto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _getImage(ImageSource.gallery),
                          child: Text('Seleccionar de Galería'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} 