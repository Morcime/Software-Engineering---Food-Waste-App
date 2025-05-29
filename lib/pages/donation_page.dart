import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _selectedOrg;
  bool _isSubmitting = false;

  // Dummy data
  final List<String> _organizations = [
    'Panti Asuhan Bahagia',
    'Rumah Singgah Sejahtera',
    'Food Bank Indonesia'
  ];

  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (!['jpg', 'jpeg', 'png'].contains(image.path.split('.').last.toLowerCase())) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Format file tidak didukung (hanya .jpg/.png)')),
          );
          return;
        }
        setState(() => _imageFile = File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _submitDonation() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Data tidak boleh kosong')),
      );
      return;
    }

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Harap upload foto makanan')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulasi proses submit
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donasi berhasil disubmit!')),
      );

      // Simulasi notifikasi setelah 5 detik
      Future.delayed(const Duration(seconds: 5), () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Donasi Diambil'),
            content: Text('Donasi "${_foodNameController.text}" telah diambil oleh ${_selectedOrg ?? "penerima"}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donasi Makanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Upload Gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile == null
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 50),
                      Text('Tap untuk upload foto'),
                    ],
                  )
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),

              // Form Input
              TextFormField(
                controller: _foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Harap isi nama makanan' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Harap isi deskripsi' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (porsi)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Harap isi jumlah' : null,
              ),
              const SizedBox(height: 20),

              // Pilih Organisasi
              DropdownButtonFormField(
                value: _selectedOrg,
                items: _organizations.map((org) {
                  return DropdownMenuItem(
                    value: org,
                    child: Text(org),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedOrg = value),
                decoration: const InputDecoration(
                  labelText: 'Pilih Organisasi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null ? 'Harap pilih organisasi' : null,
              ),
              const SizedBox(height: 30),

              // Tombol Submit
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitDonation,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('DONASIKAN', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}