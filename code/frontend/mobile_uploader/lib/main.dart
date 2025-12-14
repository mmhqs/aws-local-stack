import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

const String uploadUrl = 'http://localhost:3000/upload-image';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LocalStack Uploader',
      home: ImageUploadScreen(),
    );
  }
}

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  XFile? _pickedFile;
  bool _isUploading = false;
  String? _statusMessage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedFile = pickedFile; // Armazena o XFile
        _statusMessage = 'Imagem selecionada. Pronta para upload.';
      } else {
        _statusMessage = 'Nenhuma imagem selecionada.';
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_pickedFile == null) {
      // ... (código inalterado)
      return;
    }

    setState(() {
      _isUploading = true;
      _statusMessage = 'Enviando imagem para o Backend...';
    });

    try {
      // 1. LÊ OS BYTES DA IMAGEM: Esta é a chave para o Flutter Web!
      final fileBytes = await _pickedFile!.readAsBytes();
      final fileName = _pickedFile!.name; // Pega o nome do arquivo original

      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // 2. USA O MÉTODO fromBytes (compatível com a Web)
      request.files.add(
        http.MultipartFile.fromBytes(
          'image', // CHAVE ESPERADA NO BACKEND (multer.single('image'))
          fileBytes,
          filename: fileName, // Nome do arquivo é importante para o backend
          // Usa o mimeType para ajudar o backend a identificar o tipo de arquivo
          contentType: MediaType('image', fileName.split('.').last), 
        ),
      );
      
      // O restante do código de requisição permanece o mesmo
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        // ... (código de sucesso inalterado)
      } else {
        // ... (código de falha inalterado)
      }
    } catch (e) {
      // ... (código de erro inalterado)
    } finally {
      // ... (código finally inalterado)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalStack S3 Demo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_pickedFile != null)
                // Se for Web, precisamos ler os bytes e usar Image.memory
                Expanded(
                  child: FutureBuilder<Uint8List>(
                    future: _pickedFile!
                        .readAsBytes(), // Lê os bytes do arquivo
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!, // Exibe a imagem a partir dos bytes
                          fit: BoxFit.contain,
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Nenhuma imagem. Clique abaixo para selecionar.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

              const SizedBox(height: 20),

              // Botão Selecionar Imagem
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Selecionar imagem'),
              ),

              const SizedBox(height: 10),

              // Botão Upload
              ElevatedButton.icon(
                onPressed: _isUploading || _pickedFile == null
                    ? null
                    : _uploadImage,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(
                  _isUploading ? 'Enviando...' : 'Salvar imagem no S3',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              // Área de Status
              Text(
                _statusMessage ?? 'Aguardando ação...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _statusMessage?.contains('SUCESSO') == true
                      ? Colors.green
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
