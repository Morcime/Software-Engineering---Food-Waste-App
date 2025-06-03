import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationHistoryPage extends StatefulWidget {
  const DonationHistoryPage({super.key});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  final user = FirebaseAuth.instance.currentUser;

  void markAsPickedUp(String donationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .update({'isPickedUp': true});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donasi ditandai sebagai sudah diambil.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Silakan login untuk melihat riwayat donasi.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Donasi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donations')
            .where('userId', isEqualTo: user!.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada riwayat donasi.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data()! as Map<String, dynamic>;

              final foodName = data['foodName'] ?? '-';
              final quantity = data['quantity']?.toString() ?? '-';
              final orphanage = data['shelterName'] ?? '-';
              final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
              final isPickedUp = data['isPickedUp'] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Makanan: $foodName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah: $quantity'),
                      Text('Tujuan: $orphanage'),
                      Text('Tanggal: ${createdAt?.toLocal().toString().split('.')[0] ?? '-'}'),
                    ],
                  ),
                  trailing: isPickedUp
                      ? const Chip(
                          label: Text('Picked Up', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.green,
                        )
                      : ElevatedButton(
                          onPressed: () => markAsPickedUp(doc.id),
                          child: const Text('Tandai Sudah Diambil'),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
