import 'package:flutter/material.dart';
import 'package:farmafriend/currentUserProfileData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'alreadyBought.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class Buy extends StatefulWidget {

  Buy();
  @override
  BuyState createState() => BuyState();
}

class BuyState extends State<Buy> {

  final dbRefBuy = FirebaseDatabase.instance.reference().child("Inventory");
  String searchField;
  final GlobalKey<
      ScaffoldState> _scaffoldKey = new GlobalKey< //Mainly for snackbar
      ScaffoldState>();
  TextEditingController search = TextEditingController();
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.history),
        backgroundColor: Color(0xFF3CB371),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context){
                return AlreadyBought();
              }
          ));
        },
      ),
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
                      "Buy",
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
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                children: <Widget>[
                  Padding(  // For the search bar where items can be searched
                    padding: EdgeInsets.only(left: 30.0),
                    child: SizedBox(
                      child: TextFormField(
                        controller: search,
                        textAlign: TextAlign.center,
                      ),
                      width: widthScreen*(0.5),
                    ),
                  ),
                  Container(
                    width: 30.0,
                  ),
                  RaisedButton( // Search Button
                    color: Color(0xFF3CB371),
                    child: Text('Search', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        if(search.text == ""){
                          searchField = null;
                        }
                        else{
                          searchField = search.text;
                        }
                      });
                    },
                  )
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: FutureBuilder(
              future: dbRefBuy.orderByChild("Buyer").equalTo("Null").once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
                if(snapshot.hasData){
                  //print(snapshot.data.value);
                  Map<dynamic, dynamic> values = snapshot.data.value;  //Map of the data received
                  List<dynamic> lists = [];
                  values.forEach((x,y) {
                    List<dynamic> temp = [];
                    bool toPut = true;
                    y.forEach((a,b){
                      temp.add(b);
                      if(a == "Location" && b != currentUserData.city){
                        toPut = false;
                      }
                      if(a == "Product" && searchField != null){
                        if(!b.toLowerCase().contains(searchField.toLowerCase())){  // searchField.toLowerCase() != b.toString().toLowerCase()  !b.toLowerCase().contains(searchField.toLowerCase())
                          toPut = false;
                        }
                      }
                    });
                    if(toPut){
                      lists.add([x,temp]);
                    }
                  });
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
                                    title: Text(lists[index][1][3] + "  " + lists[index][1][4], textScaleFactor: 1.1,style: TextStyle(color: Colors.white),),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "By ${lists[index][1][6]} "
                                          ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 1.0),
                                              child: tickOrNot(lists[index][1][1]),
                                            )
                                          ),
                                          TextSpan(
                                            text: "at Rs ${lists[index][1][7]}"
                                          )
                                        ]
                                      ),
                                    ),
                                    trailing: FlatButton(
                                      child: Text("Buy", textScaleFactor: 1.1,style: TextStyle(color: Colors.white),),
                                      onPressed: (){
                                        _displayDialog(context, lists[index]);
                                      },
                                    ),
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

  tickOrNot(String name){
   if(name == 'Yes'){
     return Padding(
       padding: EdgeInsets.only(right: 2.0),
       child: Icon(Icons.check_circle_outline, size: 16.0, color: Colors.white,),
     );
   }
  }

  _displayDialog(BuildContext context, List item) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Buy Item'),
            content: Text('Are you sure you want buy this item ?'),
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
                  buyItem(item);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> buyItem(List items) async {
    String email = items[1][2];
    var cost = items[1][7];
    String product = items[1][3];
    String quantity = items[1][4];
    String seller = items[1][6];
    String verified = items[1][1];
    String itemNumber = items[0];
    if (seller == currentUserData.UserName) {
      showSnackBar("You cannot purchase your own item");
    }
    else
      {
      final MailOptions mailOptions = MailOptions(
        body: 'Hello $seller, I am ${currentUserData
            .UserName}. I have bought $product from you and would like you to deliver $quantity of it '
            'to ${currentUserData.address} for $cost. Thank You',
        subject: 'Product Bought',
        recipients: [email],
        isHTML: true,
        ccRecipients: ['thebugslayers007@gmail.com'],
      );

    final MailerResponse response = await FlutterMailer.send(mailOptions);
    print(response);
    setState(() {
      dbRefBuy.child("$itemNumber").update(
          {
            'Buyer': currentUserData.UserName,
            'Status': 'Sold',
            'Cost': cost,
            'Product': product,
            'Quantity': quantity,
            'Seller': seller,
            'Verified': verified,
            'Location': currentUserData.city,
            'Email': email
          }
      );
      showSnackBar("Item has been successfully bought");
    });
  }
  }

  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
