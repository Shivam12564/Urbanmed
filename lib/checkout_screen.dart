import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:urbanmed/commons.dart';
import 'package:urbanmed/customer_dashboard.dart';
import 'package:urbanmed/payment.dart';

class PaymentType {
  final String title;
  bool isSelected;
  int id;

  PaymentType({required this.title, required this.isSelected, required this.id});
}

class CheckOutData {
  double? price;
  String? productName;

  CheckOutData({ this.price,  this.productName});
}

class CheckOutScreen extends StatefulWidget {

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var listcartData = <CheckOutData>[];
  int total = 0;
  int amount = 0;
  var subTotal = 0.0;
  var deliveryCharge = 25.0;
   var discount = 0.1;

  var tax = 0;
  var tempCart = <dynamic>[];
  var ispaymentonline = false;
  var listCheckedBox = <PaymentType>[
    PaymentType(title: 'Cash On Delivery', isSelected: true, id: 0,),
    PaymentType(title: 'Online', isSelected: false, id: 1),
  ];
  User? user = FirebaseAuth.instance.currentUser;
  //Gpay Code
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '100',
      status: PaymentItemStatus.final_price,
    )
  ];
  //razor payment code
  Razorpay razorpay = Razorpay();

  void onlinepayment() {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handleError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    super.initState();
  }

  void handleError(PaymentFailureResponse paymentFailureResponse) {
    print("Error");
  }

  void handleSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    print("Success");

    // if (paymentSuccessResponse != null) {
    //   addToOrder('online');
    // }
  }

  void handleExternalWallet(ExternalWalletResponse externalWalletResponse) {
    print("External wallet error");
  }

  Future<void> dispatchPayment(total) async {
    var options = {
      'key': 'rzp_test_9vrOaXUeelOwn1',
      'name': user!.displayName,
      'amount': '${total}00',
      'description': 'Payment',
      'prefill': {'contact': user!.phoneNumber, 'email': user!.email},
      'currency': 'INR',
      'external': {
        'wallet': ['wallet']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    calculateTotal();
    onlinepayment();
  }

  void calculateTotal() async {
    var cartData = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(auth.currentUser!.uid)
        .collection('Cart')
        .get();

    for (var i = 0; i < cartData.docs.length; i++) {
      var data = cartData.docs[i].data();

      var shopDatas = CheckOutData();
      shopDatas.price = double.parse(data['cost']);
      shopDatas.productName = data['productname'];
      subTotal = subTotal + shopDatas.price!;
      listcartData.add(shopDatas);
      tempCart.add(data);
    }
    var difference = subTotal-subTotal.round();
    tax = (subTotal * 18 / 100 + difference).round();
    total = (subTotal + tax + deliveryCharge).round();
    amount =(total *10 /100).round();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            // Container(
            //   height: double.infinity,
            //   width: double.infinity,
            //   child: FittedBox(
            //     fit: BoxFit.cover,
            //     child: Image.asset(
            //       'Images/background.jpg',
            //     ),
            //   ),
            // ),
            Container(
              child: Text('Select Payment Methods'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  for (var ia = 0; ia < listCheckedBox.length; ia++)
                    InkWell(
                      onTap: () {
                        for (var i = 0; i < listCheckedBox.length; i++) {
                          if (i == ia) {
                            listCheckedBox[i].isSelected = true;
                          } else {
                            listCheckedBox[i].isSelected = false;
                          }
                        }

                        setState(() {});
                      },
                      child: Container(
                        width: 150,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: listCheckedBox[ia].isSelected
                                    ? Colors.red
                                    : Colors.grey,
                                spreadRadius: 5),
                          ],
                        ),
                        child: Center(
                            child: Text(listCheckedBox[ia].title,
                                style: listCheckedBox[ia].isSelected
                                    ? TextStyle(color: Colors.white)
                                    : TextStyle(color: Colors.black))),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: listcartData.length,
                itemBuilder: (context, index) {
                  return ProductName(
                    title: listcartData[index].productName!,
                    value: listcartData[index].price.toString(),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 0.5,
                child: Container(
                  child: Column(
                    children: [
                      ProductName(
                        title: 'Sub Total',
                        value: subTotal.toString(),
                      ),
                      ProductName(title: 'Tax', value: tax.toString()),
                      ProductName(
                          title: 'Delivery Charge',
                          value: deliveryCharge.toString()),
                      ProductName(
                        title: 'Total',
                        value: total.toString(),
                      ),
                      ProductName(
                        title: 'Amount',
                        value: amount.toString(),
                      )
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Click To Complete Order'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                      )
                  )
              ),
              onPressed: () {
                var id = 0;
                for (var i = 0; i < listCheckedBox.length; i++) {
                  if (listCheckedBox[i].isSelected) {
                    id = listCheckedBox[i].id;
                    break;
                  }
                }
                if (id == 0) {
                  ispaymentonline = false;
                  addToOrder('cash_in_delivery');
                } else {
                  ispaymentonline = true;
                 addToOrder('online');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void addToOrder(String type) async {
    showProgressDialog('Please Wait...', context);
    Map<String, dynamic> data = {
      'orderAmount': total,
      'paymentType': type,
      'orderStatus': ' ',
      'deliveredon': DateTime.now().add(Duration(hours: 24)).toString(),
    };

    var documentData = await FirebaseFirestore.instance
        .collection('Customers')
        .doc(auth.currentUser?.uid)
        .collection('Orders')
        .add(data);


    for (var i = 0; i < tempCart.length; i++) {
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(auth.currentUser?.uid)
          .collection('Orders')
          .doc(documentData.id)
          .collection('products')
          .add(tempCart[i]);
    }

    removeAllProductFromCart();
  }

  void removeAllProductFromCart() async {
    await FirebaseFirestore.instance
        .collection('Customers')
        .doc(auth.currentUser?.uid)
        .collection('Cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    if (ispaymentonline) {
      dispatchPayment(total).whenComplete(() => Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentMethod() //ShowQrCodeScreen(),
                  ),
              (route) => false)
      );
      addToOrder('online');
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CustomerDashboard(),
          ),
          (route) => false);
      addToOrder('cash_in_delivery');
    }
  }
}

class ProductName extends StatelessWidget {
  final String title;
  final String value;

  const ProductName({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Text('Rs. $value'),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
