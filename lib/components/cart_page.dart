// import 'package:flutter/material.dart';
// import 'package:foode_waste_app_1/models/restaurant.dart';
// import 'package:foode_waste_app_1/pages/payment_page.dart';
// import 'package:provider/provider.dart';

// import '../components/my_button.dart';

// class CartPage extends StatelessWidget {
//   const CartPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Restaurant>(
//       builder: (context, restaurant, child) {
//         if (restaurant.cart.isEmpty) {
//           return Center(child: Text("Your cart is empty"));
//         }

//         return Scaffold(
//           appBar: AppBar(
//             title: Text("Cart"),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () {
//                   restaurant.clearCart();
//                 },
//               ),
//             ],
//           ),
//           body: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: restaurant.cart.length,
//                   itemBuilder: (context, index) {
//                     final item = restaurant.cart[index];
//                     return ListTile(
//                       title: Text(item.food.name),
//                       subtitle: Text(
//                         '${item.quantity}x Rp${item.food.price.toStringAsFixed(2)}',
//                       ),
//                       trailing: Text(
//                         'Rp${(item.totalPrice).toStringAsFixed(2)}',
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Divider(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Total:'),
//                         Text(
//                           'Rp${restaurant.getTotalPrice().toStringAsFixed(2)}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 16),
//                     MyButton(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PaymentPage(),
//                           ),
//                         );
//                       },
//                       text: "Checkout",
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // class CartPage extends StatelessWidget {
// //   const CartPage({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<Restaurant>(
// //       builder: (context, restaurant, child) {
// //         // cart
// //         final userCart = restaurant.cart;
// //
// //         // scaffold UI
// //         return Scaffold(
// //           appBar: AppBar(
// //             title: Text("Cart"),
// //             backgroundColor: Colors.transparent,
// //             foregroundColor: Theme.of(context).colorScheme.inversePrimary,
// //           ),
// //           body: Column(
// //             children: [
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: userCart.length,
// //                   itemBuilder: (context, index) {
// //                     // get individual cart
// //                     final cartItem = userCart[index];
// //
// //                     //return cart tile UI
// //                     return ListTile(title: Text(cartItem.food.name));
// //                   },
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

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
        final isCartEmpty = restaurant.cart.isEmpty;

        return Scaffold(
          appBar: AppBar(
            title: Text("Cart"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions:
                isCartEmpty
                    ? null
                    : [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          restaurant.clearCart();
                        },
                      ),
                    ],
          ),
          body:
              isCartEmpty
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Your cart is empty",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Browse our menu and add items to your cart.",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: restaurant.cart.length,
                          itemBuilder: (context, index) {
                            final item = restaurant.cart[index];
                            return ListTile(
                              title: Text(item.food.name),
                              subtitle: Text(
                                '${item.quantity}x Rp${item.food.price.toStringAsFixed(2)}',
                              ),
                              trailing: Text(
                                'Rp${(item.totalPrice).toStringAsFixed(2)}',
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
                                  'Rp${restaurant.getTotalPrice().toStringAsFixed(2)}',
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
