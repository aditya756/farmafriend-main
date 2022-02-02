import 'package:farmafriend/resources.dart';
import 'package:farmafriend/sell.dart';
import 'package:flutter/material.dart';
import 'package:farmafriend/currentUserProfileData.dart';

import 'buy.dart';
import 'myProfile.dart';

class ProfileScreenDirect extends StatefulWidget {

  ProfileScreenDirect();
  @override
  _ProfileScreenDirectState createState() => _ProfileScreenDirectState();
}

class _ProfileScreenDirectState extends State<ProfileScreenDirect> {

  _ProfileScreenDirectState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
        key: _scaffoldKey,
        body: ListView(
          children: <Widget>[
            Container(
              color: Color(0xFF3CB371),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: widthScreen*0.8),
                      child: FlatButton(
                        child: Text('Log Out', style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          print('Log out');
                          _displayDialog(context);
                        },
                      )
                  )
                ],
              ),
            ),
            Container(
                height: heightScreen * 0.1,
                decoration: BoxDecoration(
                    color: Color(0xFF3CB371),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50.00),
                        bottomLeft: Radius.circular(50.00)
                    )
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.00),
                      child: Text(
                        "Hello ${currentUserData.UserName.split(" ")[0]}",
                        style: TextStyle(
                            fontSize: 28.00,
                            color: Colors.white
                        ),
                      ),
                    )
                  ],
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: heightScreen*0.05, left: 30.00),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF3CB371),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          height: heightScreen*0.2,
                          width: widthScreen*0.4,
                          child: Padding(
                            padding: EdgeInsets.only(top: heightScreen*0.09),
                            child: Text("Buy", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: widthScreen*0.07),),
                          )
                      ),
                      onTap: (){
                        print("Tapped");
                        goto(Buy());
                      },
                    ),
                    Container(
                      width: widthScreen*0.07,
                    ),
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF3CB371),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          height: heightScreen*0.2,
                          width: widthScreen*0.4,
                          child: Padding(
                            padding: EdgeInsets.only(top: heightScreen*0.09),
                            child: Text("Sell", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: widthScreen*0.07),),
                          )
                      ),
                      onTap: (){
                        print("Tapped");
                        goto(Sell());
                      },
                    ),

                  ],
                )
            ),
            Padding(
                padding: EdgeInsets.only(top: heightScreen*0.07, left: 30.00),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF3CB371),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          height: heightScreen*0.2,
                          width: widthScreen*0.4,
                          child: Padding(
                            padding: EdgeInsets.only(top: heightScreen*0.09),
                            child: Text('Resources', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: widthScreen*0.07),),
                          )
                      ),
                      onTap: (){
                        print("Tapped");
                        goto(Resources());
                      },
                    ),
                    Container(
                      width: widthScreen*0.07,
                    ),
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF3CB371),
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          height: heightScreen*0.2,
                          width: widthScreen*0.4,
                          child: Padding(
                            padding: EdgeInsets.only(top: heightScreen*0.09),
                            child: Text("My Profile", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: widthScreen*0.07),),
                          )
                      ),
                      onTap: (){
                        print("Tapped");
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context){
                              return myProfile();
                            }
                        ));
                      },
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

  void goto(var page){
    if(currentUserData.city == 'Null'){
      showSnackBar('Please go to My Profile and set city');
    }
    else if(currentUserData.address == 'Null'){
      showSnackBar('Please go to My Profile and set address');
    }
    else{
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context){
            return page;
          }
      ));
    }
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Log Out'),
            content: Text('Are you sure you want to log out ?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                },
              )
            ],
          );
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
