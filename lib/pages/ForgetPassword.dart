import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutritionapp/pages/SignIn.dart';
import '../user.dart';
import '../databaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';


class forgetpassword extends StatefulWidget {
  final togglePage;
  forgetpassword({required this.togglePage});


  @override
  State<forgetpassword> createState() => _forgetpasswordState();
}

class _forgetpasswordState extends State<forgetpassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/pw1.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 100, top: 190),
              child: Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 40,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.40,
                  right: 35,
                  left: 35,
                ),
                child: Column(
                  children: [
                    TextField(
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
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Add your logic here for the "Send Request" button
                          },
                          child: Text(
                            "Send Request",
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: loadingVisible,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.brown,
                            child: SpinKitWave(
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.brown,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                loadingVisible = true;
                              });
                              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                                Fluttertoast.showToast(msg: "We have sent a password reset email.");
                                setState(() {
                                  loadingVisible = false;
                                });



                                // Navigate to the new page here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => signin(togglePage: widget.togglePage,),
                                  ),
                                );


                              }).onError((error, stackTrace) {
                                Fluttertoast.showToast(msg: error.toString());
                                setState(() {
                                  loadingVisible = false;
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}