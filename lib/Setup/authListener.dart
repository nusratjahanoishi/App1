import 'package:firebase_auth/firebase_auth.dart';
import '../pages/home.dart';
import 'authentication.dart';
import 'package:flutter/material.dart';


import 'package:nutritionapp/pages/homepage.dart';

class AuthListener extends StatelessWidget {
  const AuthListener({super.key});

  @override
  Widget build(BuildContext context) {

    // creating an instance of firebase auth to allow us to communicate with firebase auth class
    final FirebaseAuth _auth = FirebaseAuth.instance;


    // Send either in authentication or in home
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final result = snapshot.data;
            // print("result:: ${result}");
            return Profile(result!.uid);
          } else {
            return Authentication();
          }
        }
    );
  }
}
