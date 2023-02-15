import 'package:flutter/material.dart';

import '../services/firebase_authentication.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await Auth.instance.signOut();
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
