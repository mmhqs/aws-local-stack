import 'package:flutter/material.dart';
import 'screens/image_upload_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LocalStack Uploader',
      debugShowCheckedModeBanner: false,
      home: ImageUploadScreen(),
    );
  }
}