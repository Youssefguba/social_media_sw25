import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: usersCollection.doc(userId).get(),
      builder: (context, snapshot) {

        if(snapshot.hasError) {
          return SizedBox(child: Text('There is an error'));
        }

        if(snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>;


          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(data['profile_picture']),
              ),

              ListTile(
                title: Text('Email'),
                subtitle: Text(data['email']),
              ),

              ListTile(
                title: Text('Name'),
                subtitle: Text(data['user_name']),
              ),


            ],
          );
        }

        return Center(child: CircularProgressIndicator());


      }
    );
  }
}
