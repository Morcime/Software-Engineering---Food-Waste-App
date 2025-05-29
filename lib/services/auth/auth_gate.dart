import 'package:flutter/material.dart';
import 'package:foode_waste_app_1/pages/home_page.dart';
import 'package:foode_waste_app_1/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthGate extends StatelessWidget{
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream:FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // user is logged in
          if(snapshot.hasData){
            return HomePage();
          }else{
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}