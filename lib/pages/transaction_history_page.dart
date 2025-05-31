import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foode_waste_app_1/services/auth/database/firestore.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late final User? user;
  final FireStoreService db = FireStoreService();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Silakan login untuk melihat riwayat transaksi.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('transaction_history')
            .where('userId', isEqualTo: user!.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada riwayat transaksi.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data()! as Map<String, dynamic>;
              final status = data['status'] ?? 'Unknown';
              final totalPrice = data['totalPrice'] ?? 0;
              final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
              final receipt = data['receipt'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Total: Rp $totalPrice'),
                  subtitle: Text(
                    'Status: $status\nTanggal: ${createdAt != null ? '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2,'0')}' : '-'}',
                  ),
                  isThreeLine: true,
                  trailing: status != 'delivered'
                      ? ElevatedButton(
                          child: const Text('Tandai Delivered'),
                          onPressed: () async {
                            try {
                              await db.updateOrderStatus(doc.id, 'delivered');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Status diupdate ke Delivered')),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error update status: $e')),
                                );
                              }
                            }
                          },
                        )
                      : const Icon(Icons.check, color: Colors.green),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Detail Transaksi'),
                        content: SingleChildScrollView(child: Text(receipt)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Tutup'),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
