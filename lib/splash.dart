import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:farmafriend/profile.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  @override
  void initState() {
    checkSignInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "The Bug Slayers",
            style: TextStyle(fontSize: 30),
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  void checkSignInStatus() async {
    await Future.delayed(Duration(seconds: 1));
    bool isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      print('user signed in');
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ProfileScreen()
      ));
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => LoginScreen()
      ));
    }
  }
}