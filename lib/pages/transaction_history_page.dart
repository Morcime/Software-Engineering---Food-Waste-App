import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foode_waste_app_1/services/auth/database/firestore.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final FireStoreService db = FireStoreService();

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Silakan login untuk melihat riwayat transaksi.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transaction_history')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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

              return ListTile(
                title: Text('Total: Rp $totalPrice'),
                subtitle: Text('Status: $status\nTanggal: ${createdAt?.toLocal().toString() ?? '-'}'),
                isThreeLine: true,
                trailing: status != 'delivered'
                    ? ElevatedButton(
                        child: const Text('Tandai Delivered'),
                        onPressed: () async {
                          await db.updateOrderStatus(doc.id, 'delivered');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Status diupdate ke Delivered')),
                          );
                        },
                      )
                    : const Icon(Icons.check, color: Colors.green),
                onTap: () {
                  // Optional: tampilkan detail receipt/order
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
              );
            },
          );
        },
      ),
    );
  }
}
