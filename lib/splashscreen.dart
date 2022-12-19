import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanmed/customer_dashboard.dart';
import 'package:urbanmed/retailer_dashboard.dart';
import 'package:urbanmed/screen.dart';

class Splash extends StatefulWidget {
  @override
  Splashscreen createState() => Splashscreen();
}

class Splashscreen extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Screen()));
      var defaultWidget = await getDefaultWidget();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => defaultWidget,
        ),
      );
    });
  }

  Future<Widget> getDefaultWidget() async {
    Widget _defaultWidget = Screen();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (!prefs.getBool('islogin')!) {
        _defaultWidget = Screen();
      } else {
        var type = prefs.getString('type');
        if (type != null) {
          if (type == 'retail') {
            _defaultWidget = Ddashboard();
          } else {
            _defaultWidget = CustomerDashboard();
          }
        } else {
          _defaultWidget = Screen();
        }
      }
    } catch (e) {
      _defaultWidget = Screen();
    }
    return _defaultWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              //backgroundColor: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffffffff), Color(0xff40ffff)],
                ),
              ),
              child: Center(
                child: Text(
                  "LocalMart",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
