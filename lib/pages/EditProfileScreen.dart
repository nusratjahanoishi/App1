import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  late User _user;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _aboutYouController = TextEditingController();
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = _auth.currentUser!;
    DocumentSnapshot userSnapshot = await users.doc(_user.uid).get();

    setState(() {
      _fullNameController.text = userSnapshot['full name'];
      _ageController.text = userSnapshot['age'].toString();
      _heightController.text = userSnapshot['height'].toString();
      _weightController.text = userSnapshot['weight'].toString();
      _locationController.text = userSnapshot['location'] ?? '';
      _aboutYouController.text = userSnapshot['aboutYou'] ?? '';
      _profileImageUrl = userSnapshot['profileImageUrl'];
    });
  }

  Future<void> _updateUserProfile() async {
    try {
      await users.doc(_user.uid).update({
        'full name': _fullNameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'height': int.tryParse(_heightController.text) ?? 0,
        'weight': int.tryParse(_weightController.text) ?? 0,
        'location': _locationController.text,
        'aboutYou': _aboutYouController.text,
        'profileImageUrl': _profileImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User profile updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      String fileName = 'profile_${_user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = _storage.ref().child(fileName);

      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FadeInDown(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/originals/87/1f/aa/871faa5d438cc3183bee28b1d74907d1.jpg'),
              fit: BoxFit.cover,
            ),
          ),

          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _uploadImage,
                    child: _profileImageUrl != null
                        ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_profileImageUrl!),
                    )
                        : CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.lightGreen,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _fullNameController.text,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInDown(
                    child: TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInDown(
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInDown(
                    child: TextField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Height',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    child: TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    child: TextField(

                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInDown(
                    child: TextField(
                      controller: _aboutYouController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'About You (up to 100 sentences)',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInLeftBig(
                    child: ElevatedButton(
                      onPressed: _updateUserProfile,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen,
                      ),
                      child: Text('Update Profile'),
                    ),
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
