import 'package:flutter/material.dart';
import 'package:urbanmed/customer_dashboard.dart';

class ShowQrCodeScreen extends StatefulWidget {
  @override
  _ShowQrCodeScreenState createState() => _ShowQrCodeScreenState();
}

class _ShowQrCodeScreenState extends State<ShowQrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scan and pay'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'Images/qr_code.jpeg',
              ),
              ElevatedButton(
                child: Text('Done'),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => CustomerDashboard(),
                      ),
                      (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
