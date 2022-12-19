import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
  import 'package:urbanmed/loading.dart';
import 'package:urbanmed/no_data_Found.dart';

class CustomerProductScreen extends StatefulWidget {
  final String? shopId;
  final String? shopName;

  CustomerProductScreen({this.shopId, this.shopName}) : super();

  @override
  _CustomerProductScreenState createState() => _CustomerProductScreenState();
}

class _CustomerProductScreenState extends State<CustomerProductScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchcontroller = TextEditingController();
  bool searchState = false;
  var query;

  var queryResult = [];
  var temp = [];
  bool loading = false;

  //search bar code
  searchProduct(String search) async {
    return FirebaseFirestore.instance
        .collection('Retailer')
        .doc(widget.shopId)
        .collection("ProductData")
        .where('productname', isEqualTo: search.substring(0, 1).toUpperCase())
        .get();
  }

  initiateState(value) {
    if (value == 0) {
      setState(() {
        queryResult = [];
        temp = [];
      });
    }
    var letter = value.substring(0, 1).toUpperCase() + value.sunstring(1);
    if (queryResult.length == 0 && value.length == 1) {
      searchProduct(value).then((QuerySnapshot data) {
        for (int i = 0; i < data.docs.length; ++i) {
          queryResult.add(data.docs[i].data());
        }
      });
    } else {
      temp = [];
      queryResult.forEach((element) {
        if (element['productname'].startsWith(letter)) {
          setState(() {
            temp.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        searchState = !searchState;
                      });
                    }),
              ],
              title: !searchState
                  ? Text(widget.shopName!)
                  : TextField(
                      controller: searchcontroller,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Product Name",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
              //title: Text(widget.shopName ?? 'Products'),
            ),
            body: loading
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: searchcontroller.text.length > 0
                        ? FirebaseFirestore.instance
                            .collection('Retailer')
                            .doc(widget.shopId)
                            .collection("ProductData")
                            .where('productname',
                                isEqualTo: searchcontroller.text)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('Retailer')
                            .doc(widget.shopId)
                            .collection("ProductData")
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data?.docs.length == 0) {
                          return NoDataFoundWidget();
                        } else {
                          return new ListView(
                              padding: EdgeInsets.all(8),
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                var data = document;
                                return Card(
                                  elevation: 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Product Name: ${data['productname']}"),
                                      Text(
                                          "Medicine Type: ${data['medicinetype']}"),
                                      Text(
                                          "Manufacturing Date: ${data['manufacture_date']}"),
                                      Text(
                                          "Expiry Date: ${data['expiry_date']}"),
                                      Text(
                                          "Cost: ${data['cost'].toString()}"),
                                      Center(
                                        child: ElevatedButton(
                                            child: Text('Add To Cart'),
                                            onPressed: () async {
                                              // await FirebaseFirestore.instance
                                              //     .collection('Customers')
                                              //     .doc(auth.currentUser!.uid)
                                              //     .collection('Cart')
                                              //     .add(data);
                                              // showMyDialog(context, 'Success!!',
                                              //     'your product add successfully go to cart and checkout you order');
                                            }),
                                      )
                                    ],
                                  ),
                                );
                              }).toList());
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
          );
  }

  Widget buildcard(element) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Retailer')
                .doc(widget.shopId)
                .collection('ProductData')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView(
                    padding: EdgeInsets.all(8),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                          var data = document;
                      return Card(
                        elevation: 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "Product Name: ${data['productname']}"),
                            Text(
                                "Medicine Type: ${data['medicinetype']}"),
                            Text(
                                "Manufacturing Date: ${data['manufacture_date']}"),
                            Text(
                                "Expiry Date: ${data['expiry_date']}"),
                            Text("Cost: ${data['cost'].toString()}"),
                            Center(
                              child: ElevatedButton(
                                  child: Text('Add To Cart'),
                                  onPressed: () async {
                                    // await FirebaseFirestore.instance
                                    //     .collection('Customers')
                                    //     .doc(auth.currentUser!.uid)
                                    //     .collection('Cart')
                                    //     .add(data);
                                    // showMyDialog(context, 'Success!!',
                                    //     'your product add successfully go to cart and checkout you order');
                                  }),
                            )
                          ],
                        ),
                      );
                    }).toList());
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
  }
}
