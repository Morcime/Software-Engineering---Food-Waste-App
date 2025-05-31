import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foode_waste_app_1/models/restaurant.dart';
import 'package:foode_waste_app_1/services/auth/database/firestore.dart';
import 'package:foode_waste_app_1/pages/my_receipt.dart';
import 'package:foode_waste_app_1/pages/home_page.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FireStoreService db = FireStoreService();
  String? currentOrderDocId;
  String? receipt;

  @override
  void initState() {
    super.initState();

    // Delay supaya context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final restaurant = context.read<Restaurant>();
      receipt = restaurant.displayCartReceipt();
      double totalPrice = restaurant.getTotalPrice();

      // Simpan order dan simpan docId untuk update status
      db.saveOrderToHistory(receipt: receipt!, totalPrice: totalPrice).then((docId) {
        setState(() {
          currentOrderDocId = docId;
        });
      });
    });
  }

  void navigateToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jika receipt null, tampil loading atau pesan
    if (receipt == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery in progress.."),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: navigateToHomePage,
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Column(
        children: [
          // Pakai widget MyReceipt yang menampilkan isi receipt
          const MyReceipt(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: currentOrderDocId == null
                ? null
                : () async {
                    await db.updateOrderStatus(currentOrderDocId!, 'delivered');
                    context.read<Restaurant>().clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesanan telah diterima!')),
                    );
                    navigateToHomePage();
                  },
            child: const Text('Saya sudah menerima pesanan'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kyungsoo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                "Driver",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
