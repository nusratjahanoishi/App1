import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutritionapp/user.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference _bmiRecordsCollection = FirebaseFirestore.instance.collection('bmi_records');

  Future createUserDoc(String uid, String name, String email, String role) async {
    final docUser = _userCollection.doc(uid);
    final CustomUser customUser = CustomUser(uid, name, email, role);
    final jsonUser = customUser.toJson();
    return await docUser.set(jsonUser);
  }

  Future registerUser(String name, String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      await createUserDoc(user!.uid, name, email, role);
      return CustomUser(user.uid, name, email, role);
    } catch (message) {
      print("Register Error message: ${message.toString()}");
      return message;
    }
  }

  CustomUser userObjectFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(snapshot.id, snapshot.get('name'), snapshot.get('email'), snapshot.get('role'));
  }

  Stream<CustomUser> getUserByUserID(String uid) {
    return _userCollection.doc(uid).snapshots().map(userObjectFromSnapshot);
  }

  Future loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
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

  Future storeBMIRecord(String uid, double weight, int heightFt, int heightInch, double bmi) async {
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
  Future updateUserProfile(String uid, double weight, int heightFt, int heightInch, String? profilePicUrl) async {
    try {
      await _userCollection.doc(uid).update({
        'weight': weight,
        'heightFt': heightFt,
        'heightInch': heightInch,
        'profilePicUrl': profilePicUrl,
      });
    } catch (e) {
      print("Error updating user profile: $e");
    }
  }
}