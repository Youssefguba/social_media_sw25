import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:social_media_sw25/screens/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // with custom text
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {
                // signInWithGoogle();
              },
            ),
            SignInButton(
              Buttons.Facebook,
              text: "Sign up with Facebook",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Email,
              text: "Sign up with Email",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
