import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Simpan order ke history dan kembalikan docId
  Future<String> saveOrderToHistory({
    required String receipt,
    required double totalPrice,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';

    final docRef = await _db.collection('transaction_history').add({
      'userId': user.uid,
      'receipt': receipt,
      'totalPrice': totalPrice,
      'status': 'delivering',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // Update status transaksi berdasarkan docId
  Future<void> updateOrderStatus(String docId, String newStatus) async {
    await _db.collection('transaction_history').doc(docId).update({
      'status': newStatus,
    });
  }

  // menyimpan riwayat transaksi
  Future<void> checkoutOrder({
    required String userId,
    required int totalPrice,
    required String receipt,
  }) async {
    await _db.collection('transaction_history').add({
      'userId': userId, // konsisten lowercase
      'totalPrice': totalPrice,
      'receipt': receipt,
      'status': 'processing',
      'createdAt': Timestamp.now(),
    });
  }

  // Hapus semua item dalam cart
  Future<void> clearCart(String userId) async {
    final cartRef = _db.collection('carts').doc(userId).collection('items');
    final snapshot = await cartRef.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }



}
