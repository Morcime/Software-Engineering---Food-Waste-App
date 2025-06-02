import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foode_waste_app_1/components/my_button.dart';
import 'package:foode_waste_app_1/components/my_textfield.dart';
import 'package:foode_waste_app_1/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedRole = 'Pembeli';

  void register() async {
    final _authService = AuthService();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('All fields must be filled.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match!'),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await _authService.signUpWithEmailPassword(email, password);
      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'role': selectedRole,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Registration successful! Please log in.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onTap?.call();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Registration error: $e'); // for debug

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_open_rounded, size: 72, color: Theme.of(context).colorScheme.inversePrimary),
              const SizedBox(height: 25),
              Text("Let's create an account for you", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary)),
              const SizedBox(height: 25),
              MyTextField(controller: emailController, hintText: "Email", obscureText: false),
              const SizedBox(height: 10),
              MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
              const SizedBox(height: 10),
              MyTextField(controller: confirmPasswordController, hintText: "Confirm password", obscureText: true),
              const SizedBox(height: 25),
              Text("Register as:", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.inversePrimary)),
              ListTile(
                title: const Text('Pembeli'),
                leading: Radio<String>(
                  value: 'Pembeli',
                  groupValue: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
              ),
              ListTile(
                title: const Text('Penjual'),
                leading: Radio<String>(
                  value: 'Penjual',
                  groupValue: selectedRole,
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
              ),
              const SizedBox(height: 10),
              MyButton(text: 'Sign Up', onTap: register),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Login now", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
