import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Resources extends StatefulWidget {

  Resources();
  @override
  ResourcesState createState() => ResourcesState();
}

class ResourcesState extends State<Resources> {

  ResourcesState();
  final dbRefResources = FirebaseDatabase.instance.reference().child("Resources");
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery  //To find height of screen
        .of(context)
        .size
        .height;
    double widthScreen = MediaQuery  //To find width of screen
        .of(context)
        .size
        .width;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<  //Mainly for snackbar
        ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey, //Scaffold Key
        body: ListView(
          children: <Widget>[
            Container(
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
                    Padding(  //The word Resources on the rounded background
                      padding: EdgeInsets.only(top: 30.00),
                      child: Text(
                        "Resources",
                        style: TextStyle(
                            fontSize: 32.00,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                )
            ),
            Padding(  //This is for the list of all items and their quantities
              padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 30.0),
              child: FutureBuilder(
                  future: dbRefResources.once(),
                  builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      //lists.clear();
                      print("Two");
                      print(snapshot.data);
                      List<dynamic> values = snapshot.data.value;  //Map of the data received
                      List<dynamic> lists = [];
                      print("One");
                      values.forEach((element) {
                        lists.add(element);
                      });
                      lists.remove(null);
                      print(lists);
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
                                        title: Text(lists[index], textScaleFactor: 1.1,style: TextStyle(color: Colors.white),),  //Resource
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
                  }),
            )
          ],
        )
    );
  }
}