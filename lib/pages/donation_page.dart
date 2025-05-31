import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DonationPage extends StatefulWidget {
  final bool isSeller;
  const DonationPage({super.key, required this.isSeller});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  File? pickedImage;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('donation_images')
          .child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Upload image error: $e');
      return null;
    }
  }

  Future<void> submitDonation() async {
    final name = productNameController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty || selectedDate == null || pickedImage == null) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Semua field harus diisi dan foto harus dipilih!'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final imageUrl = await uploadImage(pickedImage!);

    if (imageUrl == null) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Gagal mengupload foto. Silakan coba lagi.'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('donations').add({
      'userId': user.uid,
      'productName': name,
      'description': description,
      'expiryDate': selectedDate,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      isLoading = false;
      productNameController.clear();
      descriptionController.clear();
      selectedDate = null;
      pickedImage = null;
    });

    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Sukses'),
        content: Text('Donasi berhasil dikirim!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSeller) {
      return Scaffold(
        appBar: AppBar(title: const Text("Donasi")),
        body: const Center(
          child: Text("Halaman ini hanya untuk Penjual."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Donasi Makanan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                selectedDate == null
                    ? "Pilih Tanggal Kedaluwarsa"
                    : "Kedaluwarsa: ${selectedDate!.toLocal().toString().split(' ')[0]}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 10),

            // Image picker
            InkWell(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: pickedImage == null
                    ? const Center(child: Text('Tap untuk pilih foto'))
                    : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: submitDonation,
                    child: const Text("Kirim Donasi"),
                  ),
          ],
        ),
      ),
    );
  }
}
