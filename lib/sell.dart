import 'package:farmafriend/alreadySold.dart';
import 'package:flutter/material.dart';
import 'package:farmafriend/currentUserProfileData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class Sell extends StatefulWidget {

  Sell();
  @override
  SellState createState() => SellState();
}

class SellState extends State<Sell> {

  final dbRefBuy = FirebaseDatabase.instance.reference().child("Inventory");
  final dbRefProduct = FirebaseDatabase.instance.reference().child("Products");
  final GlobalKey<
      ScaffoldState> _scaffoldKey = new GlobalKey< //Mainly for snackbar
      ScaffoldState>();
  TextEditingController cost = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController quantity = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final List<DropdownMenuItem> items = [];
  String productName;
  double costOfProduct;
  double quantityOfProduct;
  double totalCost;

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
        backgroundColor: Color(0xFF3CB371),
        child: Icon(Icons.history),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context){
                return AlreadySold();
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
                      "Sell",
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Product", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: FutureBuilder(
                        future: dbRefProduct.once(),
                        builder: (
                            BuildContext context,
                            AsyncSnapshot<DataSnapshot> snapshot) {
                          if(snapshot.hasData){
                            // print('Data : ${snapshot.data.value}');
                            items.clear();
                            Map<dynamic, dynamic> values = snapshot.data.value;
                            values.forEach((key, values) {
                              items.add(
                                  DropdownMenuItem(
                                    child: Text(key.toString()),
                                    value: key,
                                  )
                              );
                            });
                            return SearchableDropdown.single(
                              items: items,
                              value: productName,
                              hint: "Select One",
                              searchHint: "Select One",

                              onChanged: (value) {
                                setState(() {
                                  productName = value;
                                  costOfProduct = values[value];
                                  print(value);
                                });
                              },
                              isCaseSensitiveSearch: false,
                              isExpanded: true,
                            );
                          }
                          return Container(
                            height: heightScreen*0.2,
                            width: widthScreen*0.4,
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                  ),
                  Container(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Quantity (in KG)", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    width: widthScreen*0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: quantity,
                      onChanged: (val){
                        setState(() {
                          print(quantity.text);
                          if(quantity.text != ""){
                            quantityOfProduct = double.parse(quantity.text);
                          }
                          else{
                            quantityOfProduct = 0.0;
                            print('NULL');
                          }
                        });
                      },
                      validator: (String value){
                        if(value.isEmpty){
                          return 'Enter Quantity (in KG)';
                        }
                        else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Quantity',
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      "Cost", textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  SizedBox(
                    width: widthScreen*0.75,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Rs '
                        ),
                        SizedBox(
                          width: widthScreen*0.4,
                          child: findingCostOfTheProduct(),  // To get total cost
                        ),
                      ],
                    )
                  ),
                  Container(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, left: widthScreen*0.2),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Cancel',
                            textScaleFactor: 1.2,),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          color: Color(0xFF3CB371),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          width: 50.0,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if(_formKey.currentState.validate())
                            {
                              readData(product.text, quantity.text, cost.text);
                            }
                          },
                          color: Color(0xFF3CB371),
                          child: Text('Sell Product',
                            textScaleFactor: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  void readData(String product, String quantity, String cost ){
    dbRefBuy.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      Map<dynamic, dynamic> values = snapshot.value;
      int temp = 0;
      try{
        values.forEach((key, value) {
          if(temp < int.parse(key.toString().split(" ")[1])){
            temp = int.parse(key.toString().split(" ")[1]);
          }
        });
      }
      catch(e){

      }
      dbRefBuy.child("Item ${temp+1}").set(
          {
            'Buyer' : 'Null',
            'Cost' : totalCost,
            'Location': currentUserData.city,
            'Product' : productName,
            'Quantity' : '$quantityOfProduct KG',
            'Seller' : currentUserData.UserName,
            'Status' : 'Pending',
            'Verified' : currentUserData.verified,
            'Email' : currentUserData.EmailID
          }
      );
    });
    showSnackBar("Item successfully added to Marketplace");
  }

  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  findingCostOfTheProduct(){
    print(quantity.text);
    try{
      totalCost = costOfProduct*quantityOfProduct;
      return Text('$totalCost');
    }
    catch(e){
      return Text('0');
    }
  }
}