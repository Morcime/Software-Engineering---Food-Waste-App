import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Simpan order dan return orderId
  Future<String> saveOrderToDatabase(String receipt) async {
    final docRef = await _db.collection('orders').add({
      'receipt': receipt,
      'status': 'delivering',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // Update status order jadi "received"
  Future<void> updateOrderStatusToReceived({required String orderId}) async {
    await _db.collection('orders').doc(orderId).update({
      'status': 'received',
      'receivedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> uploadFood({
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _db.collection('foods').add({
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'sellerId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

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

  // Menyimpan riwayat transaksi
  Future<void> checkoutOrder({
    required String userId,
    required int totalPrice,
    required String receipt,
  }) async {
    await _db.collection('transaction_history').add({
      'userId': userId,
      'totalPrice': totalPrice,
      'receipt': receipt,
      'status': 'processing',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> clearCart(String userId) async {
    final userDoc = _db.collection('users').doc(userId);
    await userDoc.update({
      'restaurantCart': [],
    });
  }

  // --- Fungsi khusus untuk donations collectionGroup ---

  // Stream collectionGroup 'donations' milik user, order by createdAt desc
  Stream<QuerySnapshot> getUserDonationsStream(String userId) {
    return _db
        .collectionGroup('donations')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update field 'pickedUp' pada dokumen donation tertentu
  Future<void> markDonationAsPickedUp(DocumentReference docRef) async {
    await docRef.update({'pickedUp': true});
  }
}
