import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foode_waste_app_1/models/restaurant.dart';
import 'package:foode_waste_app_1/services/auth/database/firestore.dart';
import 'package:foode_waste_app_1/pages/my_receipt.dart';

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FireStoreService db = FireStoreService();
  String? currentOrderDocId;

  @override
  void initState() {
    super.initState();

    final restaurant = context.read<Restaurant>();
    String receipt = restaurant.displayCartReceipt();
    double totalPrice = restaurant.getTotalPrice();

    db.saveOrderToHistory(receipt: receipt, totalPrice: totalPrice).then((docId) {
      if (mounted) {
        setState(() {
          currentOrderDocId = docId;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery in progress.."),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),  // <-- perbaikan di sini
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: Column(
          children: [
            const MyReceipt(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: currentOrderDocId == null
                  ? null
                  : () async {
                      await db.updateOrderStatus(currentOrderDocId!, 'delivered');
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pesanan telah diterima!')),
                      );
                    },
              child: const Text('Saya sudah menerima pesanan'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
