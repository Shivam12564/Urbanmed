import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/checkout_screen.dart';
import 'package:urbanmed/no_data_Found.dart';

class CartPage extends StatefulWidget {

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          actions: <Widget>[
            ElevatedButton(
                child: Text(
                  "Clear",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Clear Cart!!!'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(
                                  'Are you sure you want to remove all product from cart'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              removeAllProductFromCart();
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Customers')
                .doc(auth.currentUser?.uid)
                .collection('Cart')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return NoDataFoundWidget();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            var dataFromSnapshot = snapshot.data?.docs[index];

                            return Card(
                              elevation: 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Product Name: ${dataFromSnapshot!['productname']}"),
                                  Text(
                                      "Medicine Type: ${dataFromSnapshot['medicinetype']}"),
                                  Text(
                                      "Manufacturing Date: ${dataFromSnapshot['manufacture_date']}"),
                                  Text(
                                      "Expiry Date: ${dataFromSnapshot['expiry_date']}"),
                                  Text(
                                      "Cost: ${dataFromSnapshot['cost'].toString()}"),
                                  Center(
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      iconSize: 24.0,
                                      color: Colors.red,
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .runTransaction((Transaction
                                                myTransaction) async {
                                          myTransaction.delete(snapshot
                                              .data!.docs[index].reference);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          padding: EdgeInsets.all(8),
                        ),
                      ),
                      snapshot.data!.docs.length == 0
                          ? Container()
                          : ElevatedButton(
                              child: Text('Continue'),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)
                                )
                            )
                        ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CheckOutScreen(),
                                ));
                              },
                            )
                    ],
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  void removeAllProductFromCart() {
    FirebaseFirestore.instance
        .collection('Customers')
        .doc(auth.currentUser!.uid)
        .collection('Cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
