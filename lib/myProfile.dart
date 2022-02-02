import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmafriend/currentUserProfileData.dart';
import 'package:firebase_database/firebase_database.dart';

class myProfile extends StatefulWidget {

  myProfile();
  @override
  myProfileState createState() => myProfileState();
}

class myProfileState extends State<myProfile> {

  myProfileState();
  final dbRefUser = FirebaseDatabase.instance.reference().child("Users");
  TextEditingController control = TextEditingController();
  final GlobalKey<
      ScaffoldState> _scaffoldKey = new GlobalKey< //Mainly for snackbar
      ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery //To find height of screen
        .of(context)
        .size
        .height;
    double widthScreen = MediaQuery //To find width of screen
        .of(context)
        .size
        .width;

    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container( // This is for the back button
            color: Color(0xFF3CB371),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.00),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
          Container(  //This is for the rounded background
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
                  Padding(  //The word Buy on the rounded background
                    padding: EdgeInsets.only(top: 30.00),
                    child: Text(
                      "My Profile",
                      style: TextStyle(
                          fontSize: 32.00,
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: FutureBuilder(
              future: dbRefUser.child(currentUserData.UserName).once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if(snapshot.hasData){
                  print(snapshot.data.value);
                  Map<dynamic, dynamic> values = snapshot.data.value;  //Map of the data received
                  List<dynamic> lists = [];
                  values.forEach((x,y) {
                    lists.add([x,y]);
                  });
                  return new ListView.builder(
                      shrinkWrap: true,
                      itemCount: lists.length,
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Color(0xFF3CB371),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: ListTile(
                                    title: Text(lists[index][0], textScaleFactor: 1.1,style: TextStyle(color: Colors.white),),
                                    subtitle: Text(lists[index][1], textScaleFactor: 1,style: TextStyle(color: Colors.white),),
                                    trailing: changeButton(lists[index][0])
                                  )
                              ),
                            ],
                          ),
                        );
                      });
                }
                return Container(  //If data still fetching, show circle progress bar
                  height: heightScreen*0.2,
                  width: widthScreen*0.4,
                  child: CircularProgressIndicator(),
                );
              },

            ),

          )
        ],
      ),
    );
  }

  changeButton(String text){
    if(text != "Username" && text != "Email" && text != "Verified"){
      return FlatButton(
        child: Text("Change", style: TextStyle(color: Colors.white),),
        onPressed: () => _displayDialog(context, text),
      );
    }
    else{
      return Container(
        height: 10.0,
        width: 10.0,
      );
    }
  }

  _displayDialog(BuildContext context, String text) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter new $text'),
              content: TextField(
                controller: control,
                decoration: InputDecoration(hintText: "Enter desired $text"),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Save'),
                  onPressed: () {
                    if(control.text != 'Null'){
                      setState(() {
                        if(text == 'City'){
                          currentUserData.city = control.text;
                          currentUserData.city = currentUserData.city[0].toUpperCase() + currentUserData.city.substring(1).toLowerCase(); // To make everything user types as Jaipur
                        }
                        else if(text == 'Password'){
                          currentUserData.Password = control.text;
                        }
                        else if(text == 'Address'){
                          currentUserData.address = control.text;
                        }

                        dbRefUser.child(currentUserData.UserName).set(
                            {
                              'Email' : currentUserData.EmailID,
                              'Username' : currentUserData.UserName,
                              'Password' : currentUserData.Password,
                              'City' : currentUserData.city,
                              'Verified' : currentUserData.verified,
                              'Address' : currentUserData.address
                            }
                        );
                        showSnackBar("$text succcessfully changed");
                        control.clear();
                        Navigator.of(context).pop();
                      });
                    }
                    else{
                      showSnackBar("Null is not supported");
                    }
                  },
                )
              ],
            );
          });
  }

  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}