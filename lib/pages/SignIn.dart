import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutritionapp/pages/googlesignin.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'googlesignin.dart';
import 'SignUp.dart';
import 'ForgetPassword.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutritionapp/databaseService.dart';
import 'EditProfileScreen.dart';
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
    return FadeInUp(
      child: Container(
        height: double.infinity,
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
              FadeInLeft(
                child: Container(
                  padding: EdgeInsets.only(left: 50, top: 210),
                  child: Text(
                    "Welcome\nBack",
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 40,
                    ),
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
                        FadeInUp(
                          child: TextFormField(
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
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                          child: TextFormField(
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
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FadeInUp(
                              child: TextButton(
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
                                              content: Text("Login falied, try again !")
                                             // content: Text("$result")
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
                            ),
                            Visibility(
                              visible: loadingVisible,
                              child: SpinKitWave(
                                color: Colors.blue,
                              ),
                            ),
                            FadeInUp(
                              child: FloatingActionButton.extended(
                                onPressed: () async
                                {
                                  final provider=Provider.of<GoogleSignInProvider>(context,listen: false);
                                  provider.googleLogin();
                              
                                },
                              
                              
                                  // Implement Google Sign In here
                              
                                icon: Image.network(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZLQmL6MrQdyrmcqs7hqL51DtWLIKPVr7Znr7ndd9Fiw&s',
                                  fit: BoxFit.cover,
                                  width: 2,
                                  height: 2,
                                ),
                                label: Text(
                                  "Sign with Google",
                                  style: TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Colors.white,
                              ),
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
                            FadeInUp(
                              child: TextButton(
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
      ),
    );
  }
}
