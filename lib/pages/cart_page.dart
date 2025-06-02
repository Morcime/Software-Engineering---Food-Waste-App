import 'package:flutter/material.dart';
import 'package:foode_waste_app_1/models/restaurant.dart';
import 'package:foode_waste_app_1/pages/payment_page.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        if (restaurant.cart.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Cart")),
            body: const Center(
              child: Text("Your cart is empty"),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Cart"),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  restaurant.clearCart();
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: restaurant.cart.length,
                  itemBuilder: (context, index) {
                    final item = restaurant.cart[index];
                    return ListTile(
                      title: Text(item.food.name),
                      subtitle: Text(
                        'Rp${item.quantity} x Rp${item.food.price.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        'Rp${item.totalPrice.toStringAsFixed(2)}',
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text(
                          'Rp${restaurant.getTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    MyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentPage(),
                          ),
                        );
                      },
                      text: "Checkout",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
