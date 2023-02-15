import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? _image;

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
              radius: 30,
              backgroundImage: Image.file(File(_image!.path)).image,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter your username',
            ),
          ),
          ElevatedButton(
            onPressed: () {},
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

  void uploadImage() async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final path = 'profile/$uid/${_image!.path}';

    File file = File(_image!.path);

    final uploadedImg = await storageRef.putFile(file);
    final url = await storageRef.getDownloadURL();

    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'profile_picutre': url,
    });
  }
}
