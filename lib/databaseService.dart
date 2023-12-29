import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'package:nutritionapp/pages/SignUp.dart';
import 'package:nutritionapp/pages/SignIn.dart';

class DatabaseService {
  // creating an instance of firebase auth to allow us to communicate with firebase auth class
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // firestore collection reference
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  // create a new document for the user with the uid
  Future createUserDoc(
      String uid, String name, String email, String role) async {
    final docUser = _userCollection.doc(uid);
    final CustomUser customUser = CustomUser(uid, name, email, role);

    final jsonUser = customUser.toJson();
    return await docUser.set(jsonUser);
  }

  Future registerUser(
      String name, String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      await createUserDoc(user!.uid, name, email, role);
      return CustomUser(user.uid, name, email, role);
    } catch (message) {
      print("Regsiter Error message: ${message.toString()}");
      return message;
    }
  }


  // Map snapshot into CustomUser object
  CustomUser userObjectFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(snapshot.id, snapshot.get('name'), snapshot.get('email'),
        snapshot.get('role'));
  }

  Stream<CustomUser> getUserByUserID(String uid) {
    return _userCollection.doc(uid).snapshots().map(userObjectFromSnapshot);
  }

  Future loginUser(String email, String password) async{
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (message) {
      print(message.toString());
      return message.toString();
    }
  }

  Future logoutUser() async{
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
}

}
