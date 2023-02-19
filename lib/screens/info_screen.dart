import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_sw25/screens/home_screen.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? _image;
  final nameController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: pickAPhoto,
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  _image != null ? Image.file(File(_image!.path)).image : null,
            ),
          ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Enter your username',
            ),
          ),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    _uploadUserData();
                  },
                  child: Text('Continue'),
                ),
        ],
      ),
    );
  }

  void pickAPhoto() async {
    _image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future<void> uploadImage() async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');

    final uid = FirebaseAuth.instance.currentUser!.uid;

    File file = File(_image!.path);

    await storageRef.putFile(file);

    final url = await storageRef.getDownloadURL();

    FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'profile_picture': url,
      },
      SetOptions(merge: true),
    );
  }

  void _uploadUserData() async {
    setState(() {
      isLoading = true;
    });
    await uploadImage();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {
        'user_name': nameController.text,
      },
      SetOptions(merge: true),
    );

    setState(() {
      isLoading = false;
    });

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
