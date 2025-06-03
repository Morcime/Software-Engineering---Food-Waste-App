import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  final bool isSeller;
  const DonationPage({super.key, required this.isSeller});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final List<String> shelterOptions = [
    'Panti Asuhan Harapan',
    'Panti Jompo Bahagia',
    'Panti Tuna Netra Cemerlang'
  ];

  String? selectedShelter;
  DateTime? selectedDate;
  bool isLoading = false;

  Future<void> submitDonation() async {
    final name = productNameController.text.trim();
    final description = descriptionController.text.trim();
    final quantityText = quantityController.text.trim();
    final quantity = int.tryParse(quantityText);

    if (name.isEmpty ||
        description.isEmpty ||
        quantity == null ||
        quantity <= 0 ||
        selectedDate == null ||
        selectedShelter == null) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Semua field harus diisi dengan benar!'),
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
      // Bisa kasih alert user harus login
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Anda harus login terlebih dahulu.'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('donations').add({
      'userId': user.uid,
      'productName': name,
      'description': description,
      'quantity': quantity,
      'expiryDate': selectedDate,
      'shelterName': selectedShelter,
      'createdAt': FieldValue.serverTimestamp(),
      'pickedUp': false,
    });

    setState(() {
      isLoading = false;
      productNameController.clear();
      descriptionController.clear();
      quantityController.clear();
      selectedDate = null;
      selectedShelter = null;
    });

    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Sukses'),
        content: Text('Donasi berhasil, makanan segera di-pick up!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSeller) {
      return Scaffold(
        appBar: AppBar(title: const Text("Donasi")),
        body: const Center(child: Text("Halaman ini hanya untuk Penjual.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donasi Makanan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
      ),
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
            TextField(
              controller: quantityController,
              decoration:
                  const InputDecoration(labelText: "Jumlah (porsi/unit)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedShelter,
              decoration: const InputDecoration(labelText: 'Pilih Panti Tujuan'),
              items: shelterOptions.map((shelter) {
                return DropdownMenuItem<String>(
                  value: shelter,
                  child: Text(shelter),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedShelter = value;
                });
              },
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
