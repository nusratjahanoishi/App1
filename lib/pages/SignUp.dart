import '../user.dart';
import '../databaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class signup extends StatefulWidget {
  final togglePage;
  signup({required this.togglePage});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool loadingVisible = false;
  final _formKeyLogin = GlobalKey<FormState>();
  DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/p23.png'),fit: BoxFit.fitWidth)),

      child: Scaffold(
        backgroundColor:Colors.transparent ,
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.only(left: 140,top: 150),
                child: Text("New Account",style: TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 40,
                ),)
            ),
      SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.35,right: 35,left: 35),




            child: Form(
              key: _formKeyLogin,
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  // for Name
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      filled: true,
                      hintText: "Name",
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),


                    onTapOutside: (event) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please Enter Your Name !';
                      } else
                        return null;
                    },
                  ),

                  SizedBox(
                    height: 30.0,
                  ),
                  // for email
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
                    onTapOutside: (event) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please Enter Email!';
                      } else {
                        return null;
                      }
                    },

                  ),
                  SizedBox(
                    height: 30.0,
                  ),

                  // for password
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      hintText: "password",
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please Enter password!';
                      } else {
                        return null;
                      }
                    },

                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  // Login Button
                  ElevatedButton(

                      onPressed: () async {
                        if (_formKeyLogin.currentState!.validate()) {
                          setState(() {
                            loadingVisible = true;
                          });
                          dynamic result = await _databaseService.registerUser(
                              nameController.text,
                              emailController.text,
                              passwordController.text,
                              "role_general_user");

                          // if (result == null){
                          if (result is! CustomUser){
                            setState(() {
                              loadingVisible = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 4),
                                    content: Text("${result}")
                                  // content: Text("Somwthing Wrong, try again !"),
                                )
                            );
                          }

                        }
                      },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Have an Account?"),
                      SizedBox(width: 10,),
                      GestureDetector(
                          onTap: () {
                            widget.togglePage();
                          },
                          child: Text("Login",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.lightGreen
                            ),)
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Visibility(
                    visible: loadingVisible,
                    child: SpinKitWave(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
      ]
        ),

      ),
    );
  }
}
