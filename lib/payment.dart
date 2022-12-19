import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:urbanmed/checkout_screen.dart';
import 'package:urbanmed/retailer_drawer.dart';

class PaymentMethod extends StatefulWidget {
  // final String title;
  // bool isSelected;
  // int id;
  // int total = 0;
  // int amount = 0;
  // var subTotal = 0.0;
  // var deliveryCharge = 25.0;
  // var discount = 0.1;
  // var tax = 0;

  PaymentMethod({
    Key? key
    // required this.title,
    // required this.isSelected,
    // required this.id,
    // required this.total,
    // required this.subTotal,
    // required this.deliveryCharge,
  }) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  int total = 0;
  int amount = 0;
  var subTotal = 0.0;
  var deliveryCharge = 25.0;
  var discount = 0.1;
  var tax = 0;
  var listcartData = <CheckOutData>[];

  User? user = FirebaseAuth.instance.currentUser;
  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

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
      'currency': 'USD',
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

    // for (var i = 0; i < cartData.docs.length; i++) {
    //   var data = cartData.docs[i].data();
    //
    //   var shopDatas = CheckOutData();
    //   shopDatas.price = double.parse(data['cost']);
    //   shopDatas.productName = data['productname'];
    //   subTotal = subTotal + shopDatas.price!;
    //   listcartData.add(shopDatas);
    //   tempCart.add(data);
    // }
    var difference = subTotal - subTotal.round();
    tax = (subTotal * 18 / 100 + difference).round();
    total = (subTotal + tax + deliveryCharge).round();
    amount = (total * 10 / 100).round();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0.0,
        title: Text(
          'Select the Payment Method',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.lime[800],
            child: GooglePayButton(
              paymentConfigurationAsset: 'gpay.json',
              paymentItems: _paymentItems,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 50,
            color: Colors.lime[600],
            child: ElevatedButton(
              //color: Colors.cyan,
              child: Text(
                'RazorPay',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)
                      )
                  )
              ),
              onPressed: () {
                onlinepayment();
              },
            )
            ),
          SizedBox(height: 20.0),
          Container(
            height: 50,
            color: Colors.lime[200],
            child: const Center(child: Text('Orange')),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
