import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:farmafriend/currentUserProfileData.dart';
import 'package:farmafriend/profile_noGoogle.dart';
import 'package:farmafriend/signUp.dart';
import 'package:farmafriend/splash.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email','profile']);
  TextEditingController emailID = TextEditingController();
  TextEditingController password = TextEditingController();
  //final dbRefUser = FirebaseDatabase.instance.reference();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(); // For snackbar
  final dbRefUser = FirebaseDatabase.instance.reference().child("Users");
  var _formKey = GlobalKey<FormState>();
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: size.height*0.75,
                    width: size.width,
                    decoration: BoxDecoration(
                        color: Color(0xFF3CB371),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(80.00),
                            bottomLeft: Radius.circular(80.00)
                        )
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: size.height*0.15, bottom: 50.0),
                          child: Text(
                            "FarmaFriend",
                            style: TextStyle(fontSize: 44,  color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width*0.8,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: emailID,
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Enter Email ID';
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Email ID',

                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                      width: 2.0
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))
                            ),
                          ),
                        ),
                        Container(
                          height: 30.0,
                        ),
                        SizedBox(
                          width: size.width*0.8,
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            controller: password,
                            validator: (String value){
                              if(value.isEmpty){
                                return 'Enter password';
                              }
                              else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Password',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2.0
                                  )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, left: size.width*0.25),
                          child: Row(
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  if(_formKey.currentState.validate())
                                  {
                                    readData(emailID.text, password.text);
                                  }
                                },
                                color: Colors.white,
                                child: Text('Sign In',
                                textScaleFactor: 1.2,),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)
                                ),
                              ),
                              Container(
                                width: 50.0,
                              ),
                              RaisedButton(
                                child: Text('Sign Up',
                                textScaleFactor: 1.2,),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)
                                ),
                                color: Colors.white,
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context){
                                        return SignUp();
                                      }
                                  ));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: size.width*0.2, right: size.width*0.2),
            child: RaisedButton(
              onPressed: () {
                startSignIn();
              },
              color: Color(0xFF3CB371),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)
              ),
              child: Text('Sign in with Google',
              style: TextStyle(
                color: Colors.white
              ),
              textScaleFactor: 1.1,),
            ),
          ),
        ],
      ),
    );
  }

  void startSignIn() async {
    await googleSignIn.signOut();
    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      showSnackBar('Sign In Failed');
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SplashScreen()
      ));
    }
  }

  void readData(String userName, String password){
    dbRefUser.once().then((DataSnapshot snapshot) {
      bool logIn = false;
      print('Data : ${snapshot.value}');
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, i){
        print(i["Email"]);
        print(i);
        if(i["Email"] == userName){
          if(i['Password'] == password){
            print("Access granted");
            print(i["Username"]);
            logIn = true;
            showSnackBar("Log In Successfully");
            currentUserData.EmailID = i['Email'];
            currentUserData.Password = i['Password'];
            currentUserData.UserName = i['Username'];
            currentUserData.city = i['City'];
            currentUserData.address = i['Address'];
            currentUserData.verified = i['Verified'];

              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return ProfileScreenDirect();
                  }
              ));

          }
          else{
            showSnackBar("Incorrect password");
          }
        }
      }
      );

      if(!logIn){
        showSnackBar("Email ID Not Found");
      }
    });
  }

  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}

