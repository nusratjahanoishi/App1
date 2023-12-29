import 'package:nutritionapp/pages/SignUp.dart';
import 'package:nutritionapp/pages/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/SignIn.dart';


class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool showLoginPage = true;
  togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Send either in login page or in register page
    if (showLoginPage) {
      return signin(togglePage: togglePage);
    } else {
      return signup(togglePage: togglePage);
    }
  }
}
