import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/upload_service.dart';

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
        _pickedFile = pickedFile;
        _statusMessage = 'Imagem selecionada. Pronta para upload.';
      } else {
        _statusMessage = 'Nenhuma imagem selecionada.';
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_pickedFile == null) {
      setState(() => _statusMessage = 'Selecione uma imagem.');
      return;
    }
    setState(() {
      _isUploading = true;
      _statusMessage = 'Enviando imagem para o Backend...';
    });
    try {
      final response = await UploadService.uploadImage(_pickedFile!);
      if (response.statusCode == 200) {
        setState(() {
          _statusMessage =
              'Upload realizado com SUCESSO!\nStatus: ${response.statusCode}\nResposta: ${response.body}';
          _pickedFile = null;
        });
      } else {
        setState(() {
          _statusMessage =
              'Upload FALHOU! Status: ${response.statusCode}\nErro: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro - $e';
      });
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('LocalStack Image Uploader :)'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_pickedFile != null)
                Expanded(
                  child: FutureBuilder<Uint8List>(
                    future: _pickedFile!.readAsBytes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
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

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Selecionar imagem'),
              ),

              const SizedBox(height: 10),

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
