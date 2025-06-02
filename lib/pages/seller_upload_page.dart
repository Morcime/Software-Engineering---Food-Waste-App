import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerUploadPage extends StatefulWidget {
  const SellerUploadPage({super.key});

  @override
  State<SellerUploadPage> createState() => _SellerUploadPageState();
}

class _SellerUploadPageState extends State<SellerUploadPage> {
  final _foodNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      print("Picked image path: ${_image?.path}");
    } else {
      print("No image selected.");
    }
  }

  // Fungsi untuk mengupload gambar ke Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        "foods/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Failed to upload image: $e");
      return null;
    }
  }

  // Fungsi untuk mengupload data makanan ke Firestore
  Future<void> _uploadFood() async {
    if (_foodNameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final imageUrl = await _uploadImage(_image!);
    if (imageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to upload image")));
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection("foods").add({
      "name": _foodNameController.text,
      "price": double.tryParse(_priceController.text) ?? 0.0,
      "description": _descriptionController.text,
      "imageUrl": imageUrl,
      "uploadedBy": currentUser?.uid,
      "timestamp": Timestamp.now(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Food uploaded successfully")));

    _foodNameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Food")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _foodNameController,
              decoration: const InputDecoration(labelText: "Food Name"),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200],
                child:
                    _image == null
                        ? const Icon(Icons.add_a_photo, size: 50)
                        : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFood,
              child: const Text("Upload Food"),
            ),
          ],
        ),
      ),
    );
  }
}
