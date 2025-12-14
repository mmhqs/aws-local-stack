// lib/services/upload_service.dart

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart' show MediaType;

const String UPLOAD_URL = 'http://localhost:3000/upload-image';

class UploadService {
  
  /// Realiza o upload de um XFile (compatível com Web) para o backend 
  /// usando o método fromBytes.
  /// @param pickedFile O XFile a ser enviado.
  /// @returns Retorna a resposta do corpo da requisição HTTP.
  static Future<http.Response> uploadImage(XFile pickedFile) async {
    final fileBytes = await pickedFile.readAsBytes();
    final fileName = pickedFile.name;
    
    final request = http.MultipartRequest('POST', Uri.parse(UPLOAD_URL));
    
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', 
        fileBytes,
        filename: fileName,
        contentType: MediaType('image', fileName.split('.').last), 
      ),
    );
    
    final response = await request.send();
    return http.Response.fromStream(response);
  }
}