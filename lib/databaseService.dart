import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutritionapp/doctors.dart';
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
  final CollectionReference _doctorCollection =
  FirebaseFirestore.instance.collection('doctor');
  Stream<List<Doctors>> getDoctorsData() {
    return _doctorCollection.snapshots().map((QuerySnapshot querySnapshot) {

      return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
        return Doctors(
          documentSnapshot.get('image'),
          documentSnapshot.get('name'),
          documentSnapshot.get('appointment'),
          documentSnapshot.get('department'),
          documentSnapshot.get('time'),
          documentSnapshot.get('rating'),
          documentSnapshot.get('uid'),
        );
      }).toList();
    });
  }
  Future setAppointmentDate(String uid,String name,String image, bool appointment,String department,String rating,DateTime date,String time,String userId)async{

    try{
      await FirebaseFirestore.instance.collection('doctor').doc(uid).update({
        'name': name,
        'image': image,
        'appointment': appointment,
        'department': department,
        'time':time,
        'uid':uid,
        'date':date,
        'rating':rating,
        'userUid':userId

      });
    }on FirebaseException catch(e){
      print("error  is  ========>${e}");
    }
  }
  Future selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      // Do something with the selected date
      print("Selected date: ${picked.toLocal()}");
    }
    return selectedDate;
  }
}
