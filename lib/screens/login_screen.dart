import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_media_sw25/screens/info_screen.dart';
import 'package:social_media_sw25/services/firebase_authentication.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Lottie.network(
              'https://assets1.lottiefiles.com/packages/lf20_KvK0ZJBQzu.json',
              height: 150,
              width: 150,
            ), // TODO change it later
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
              ),
            ),

            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                // 1 - email & pw - done
                // 2 - login with email by firebase - done
                // 3 - save data to firebase firestore
                // 4 - navigate to info screen
                final email = emailController.text;
                final password = passwordController.text;

                final userCredential = await Auth.instance
                    .createEmailWithPassword(email, password, context);

                if (userCredential != null) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'email': email,
                  },
                    SetOptions(merge: true),

                  );

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InfoScreen()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
