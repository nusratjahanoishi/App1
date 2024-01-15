// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:nutritionapp/user.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../databaseService.dart';
//
// class ProfileScreen extends StatefulWidget {
//   final String uid;
//
//   ProfileScreen(this.uid);
//
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseService _databaseService = DatabaseService();
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController heightController = TextEditingController();
//   TextEditingController weightController = TextEditingController();
//   File? _image;
//
//   @override
//   void initState() {
//     super.initState();
//     // Load existing user data
//     _loadUserData();
//   }
//
//   void _loadUserData() async {
//     CustomUser user = (await _databaseService.getUserByUserID(widget.uid)) as CustomUser;
//     setState(() {
//       nameController.text = user.name ?? '';
//       heightController.text = user.height?.toString() ?? '';
//       weightController.text = user.weight?.toString() ?? '';
//     });
//   }
//
//   Future<void> _updateProfile() async {
//     String? profilePictureUrl;
//     if (_image != null) {
//       profilePictureUrl = await _uploadProfilePicture(_image!);
//     }
//
//     await _databaseService.updateUserProfile(widget.uid, double.tryParse(weightController.text) ?? 0.0,
//         int.tryParse(heightController.text) ?? 0, 0, profilePictureUrl);
//   }
//
//   Future<String?> _uploadProfilePicture(File imageFile) async {
//     try {
//       Reference storageReference = FirebaseStorage.instance.ref().child("profile_pictures/${widget.uid}");
//       UploadTask uploadTask = storageReference.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//       return await taskSnapshot.ref.getDownloadURL();
//     } catch (e) {
//       print("Error uploading profile picture: $e");
//       return null;
//     }
//   }
//
//   Future<void> _pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//     PickedFile? pickedFile = await _picker.getImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: _image != null ? FileImage(_image!) : AssetImage('assets/default_profile_picture.jpg'),
//                   ),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _updateProfile,
//               child: Text('Save Profile'),
//             ),
//             SizedBox(height: 20),
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             TextFormField(
//               controller: heightController,
//               decoration: InputDecoration(labelText: 'Height'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: weightController,
//               decoration: InputDecoration(labelText: 'Weight'),
//               keyboardType: TextInputType.number,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _auth.signOut();
//                 Navigator.pop(context);
//               },
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
