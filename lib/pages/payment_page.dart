import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:foode_waste_app_1/pages/delivery_progress_page.dart';
import 'package:foode_waste_app_1/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foode_waste_app_1/services/auth/database/firestore.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final FireStoreService db = FireStoreService();

  int totalPrice = 50000;
  String receipt = "Order #123456";

  void userTappedPay() async {
    if (formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Payment"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("Card Number: $cardNumber"),
                Text("Expiry Date: $expiryDate"),
                Text("Card Holder Name: $cardHolderName"),
                Text("CVV: $cvvCode"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Simpan order
                  await db.checkoutOrder(
                    userId: user.uid,
                    totalPrice: totalPrice,
                    receipt: receipt,
                  );

                  // Kosongkan cart
                  await db.clearCart(user.uid);

                  // Pindah ke halaman DeliveryProgressPage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeliveryProgressPage(),
                    ),
                  );
                }
              },
              child: const Text("Yes"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all card details correctly.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text("Checkout"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  formKey: formKey,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  onCreditCardModelChange: (data) {
                    setState(() {
                      cardNumber = data.cardNumber;
                      expiryDate = data.expiryDate;
                      cardHolderName = data.cardHolderName;
                      cvvCode = data.cvvCode;
                      isCvvFocused = data.isCvvFocused;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyButton(
                onTap: userTappedPay,
                text: "Pay now",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
