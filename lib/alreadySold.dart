import 'package:flutter/material.dart';
import 'package:farmafriend/currentUserProfileData.dart';
import 'package:firebase_database/firebase_database.dart';

class AlreadySold extends StatefulWidget {

  AlreadySold();
  @override
  AlreadySoldState createState() => AlreadySoldState();
}

class AlreadySoldState extends State<AlreadySold> {
  final dbRefBuy = FirebaseDatabase.instance.reference().child("Inventory");
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
                      "Previously Bought Items",
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
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: FutureBuilder(
              future: dbRefBuy.orderByChild("Seller").equalTo(currentUserData.UserName).once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.value == null){
                    return Container(
                      height: heightScreen*0.3,
                      width: widthScreen,
                      child: Text("You have not Bought any items previously", style: TextStyle(fontSize: 20.00),textAlign: TextAlign.center,),
                    );
                  }
                  Map<dynamic, dynamic> values = snapshot.data.value;  //Map of the data received
                  List<dynamic> lists = [];
                  values.forEach((x,y) {
                    List<dynamic> temp = [];
                    y.forEach((a,b){
                      temp.add(b);
                    });
                    lists.add([x,temp]);
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
                                    title: Text(lists[index][1][3] + "  " + lists[index][1][4], textScaleFactor: 1.1,style: TextStyle(color: Colors.white),),
                                    subtitle: Text("Sold By ${lists[index][1][6]} at Rs ${lists[index][1][7]}", textScaleFactor: 1,style: TextStyle(color: Colors.white),),
                                  )
                              ),
                            ],
                          ),
                        );
                      });

                }
                else{
                  return Container(  //If data still fetching, show circle progress bar
                    height: heightScreen*0.2,
                    width: widthScreen*0.4,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}