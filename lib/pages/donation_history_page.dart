import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Donasi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .orderBy('createdAt', descending: true)  // Sorting terbaru dulu
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada donasi'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final donorName = data['productName'] ?? 'Tidak diketahui';
              final amount = data['quantity'] ?? 0;
              final pickedUp = data['pickedUp'] ?? false;

              return ListTile(
                title: Text(donorName),
                subtitle: Text('Jumlah: $amount'),
                trailing: pickedUp
                    ? const Text('Sudah diambil',
                        style: TextStyle(color: Colors.green))
                    : ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('donations')
                              .doc(docs[index].id)
                              .update({'pickedUp': true});
                        },
                        child: const Text('Picked Up'),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
