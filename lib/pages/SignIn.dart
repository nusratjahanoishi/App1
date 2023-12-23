import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignUp.dart';
import 'ForgetPassword.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutritionapp/databaseService.dart';

class signin extends StatefulWidget {

  final togglePage;
  signin({required this.togglePage});


  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  bool loadingVisible = false;
  // Added to track loading state

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/po1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 50, top: 210),
              child: Text(
                "Welcome\nBack",
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 40,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKeyLogin,
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    right: 35,
                    left: 35,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          hintText: "Email",
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please Enter Email!';
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          filled: true,
                          hintText: "Password",
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return 'Please Enter Password !';
                          } else
                            return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (_formKeyLogin.currentState!.validate()) {
                                setState(() {
                                  loadingVisible = true;
                                });
                                dynamic result = await DatabaseService().loginUser(emailController.text, passwordController.text);

                                // if (result == null){
                                if (result is! UserCredential){
                                  setState(() {
                                    loadingVisible = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 3),
                                          // content: Text("Login falied, try again !")
                                          content: Text("$result")
                                      )
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: loadingVisible,
                            child: SpinKitWave(
                              color: Colors.blue,
                            ),
                          ),
                          FloatingActionButton.extended(
                            onPressed: () async
    {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          // User canceled the Google Sign In process
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          // Google Sign In successful, do something with user
          print('Google Sign In successful: ${user.displayName}');
        }
      } catch (e) {
        // Handle errors during Google Sign In
        print('Error during Google Sign In: $e');
      }
    },

                              // Implement Google Sign In here

                            icon: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZLQmL6MrQdyrmcqs7hqL51DtWLIKPVr7Znr7ndd9Fiw&s',
                              fit: BoxFit.cover,
                              width: 20,
                              height: 20,
                            ),
                            label: Text(
                              "Sign in with Google",
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.togglePage();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => signup(togglePage:widget.togglePage,),
                              //   ),
                              // );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.lightGreen,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => forgetpassword(togglePage: widget.togglePage,),
                                ),
                              );
                            },
                            child: Text(
                              "Forget Password",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Colors.lightGreen,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
