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
          return Center(
            child: Text("Your cart is empty"),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Cart"),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
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
                        '${item.quantity}x \$${item.food.price.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        '\$${(item.totalPrice).toStringAsFixed(2)}',
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:'),
                        Text(
                          '\$${restaurant.getTotalPrice().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    MyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(),
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

// class CartPage extends StatelessWidget {
//   const CartPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Restaurant>(
//       builder: (context, restaurant, child) {
//         // cart
//         final userCart = restaurant.cart;
//
//         // scaffold UI
//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Cart"),
//             backgroundColor: Colors.transparent,
//             foregroundColor: Theme.of(context).colorScheme.inversePrimary,
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: userCart.length,
//                   itemBuilder: (context, index) {
//                     // get individual cart
//                     final cartItem = userCart[index];
//
//                     //return cart tile UI
//                     return ListTile(title: Text(cartItem.food.name));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
