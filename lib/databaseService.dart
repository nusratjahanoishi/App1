import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/Setup/allfoodsmodel.dart';
import 'package:nutritionapp/doctors.dart';
import 'package:nutritionapp/user.dart';
import 'package:nutritionapp/BMR and Calorie/Result.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference _bmiRecordsCollection = FirebaseFirestore.instance
      .collection('bmi_records');
  final CollectionReference _bmrRecordsCollection = FirebaseFirestore.instance
      .collection('bmr_records');

//  final CollectionReference _bmrRecordsCollection = FirebaseFirestore.instance.collection('bmr_records');


  Future createUserDoc(String uid, String name, String email,
      String role) async {
    final docUser = _userCollection.doc(uid);
    final CustomUser customUser = CustomUser(uid, name, email, role);
    final jsonUser = customUser.toJson();
    return await docUser.set(jsonUser);
  }

  Future registerUser(String name, String email, String password,
      String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      await createUserDoc(user!.uid, name, email, role);
      return CustomUser(user.uid, name, email, role);
    } catch (message) {
      print("Register Error message: ${message.toString()}");
      return message;
    }
  }

  CustomUser userObjectFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(snapshot.id, snapshot.get('name'), snapshot.get('email'),
        snapshot.get('role'));
  }

  Stream<CustomUser> getUserByUserID(String uid) {
    return _userCollection.doc(uid).snapshots().map(userObjectFromSnapshot);
  }

  Future loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (message) {
      print(message.toString());
      return message.toString();
    }
  }

  Future logoutUser() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future storeBMIRecord(String uid, double weight, int heightFt, int heightInch,
      double bmi) async {
    try {
      await _bmiRecordsCollection.add({
        'uid': uid,
        'weight': weight,
        'height_ft': heightFt,
        'height_inch': heightInch,
        'bmi': bmi,
        'date': DateTime.now(),
      });
    } catch (e) {
      print("Error storing BMI record: $e");
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

  Future setAppointmentDate(String uid, String name, String image,
      bool appointment, String department, String rating, DateTime date,
      String time, String userId) async {
    try {
      await FirebaseFirestore.instance.collection('doctor').doc(uid).update({
        'name': name,
        'image': image,
        'appointment': appointment,
        'department': department,
        'time': time,
        'uid': uid,
        'date': date,
        'rating': rating,
        'userUid': userId
      });
    } on FirebaseException catch (e) {
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

  Future storeBMRData(String uid, double bmr, String currentCalorie,
      String goalCalorie, DateTime date) async {
    try {
      await _bmrRecordsCollection.add({
        'uid': uid,
        'bmr': bmr,
        'current_calorie': currentCalorie,
        'goal_calorie': goalCalorie,
        'date': date,
      });
    } catch (e) {
      print("Error storing BMR data: $e");
    }
  }

  Future<void> storeBMRHistory(String userUID, // Add user's UID parameter
      double bmr,
      String currentCalorie,
      String goalCalorie,
      DateTime date,) async {
    try {
      await FirebaseFirestore.instance
          .collection('bmr_history')
          .doc(userUID) // Use the user's UID in the document path
          .collection('history')
          .add({
        'bmr': bmr,
        'currentCalorie': currentCalorie,
        'goalCalorie': goalCalorie,
        'date': date,
      });
    } catch (e) {
      print('Error storing BMR history: $e');
    }
  }
  Future<void> saveUserDetails(String uid, Map<String, dynamic> userDetails) async {
    await _firestore.collection('users').doc(uid).set(userDetails);
  }

  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(uid).get();
    return userSnapshot.data() as Map<String, dynamic>;
  }

// Implement your other methods as needed, e.g., getUserByUserID, logoutUser
  final CollectionReference _foodCollection = FirebaseFirestore.instance.collection('food');
  Stream<List<AllFoodModel>> getAllFood() {
    return _foodCollection.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
        print("================>${documentSnapshot.data()}");
        return AllFoodModel(
          documentSnapshot.get('image') ?? "", // provide a default value if null
          documentSnapshot.get('protein') ?? "",
          documentSnapshot.get('name') ?? "",
          documentSnapshot.get('ready') ?? "",
          documentSnapshot.get('isvagitarian') ?? false,
        );
      }).toList();
    });
  }


}



