import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/customer_login.dart';
import 'package:urbanmed/retailer_login.dart';

class Screen extends StatefulWidget {
  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  bool darkMode = false;

  static const MaterialColor myColour = const MaterialColor(
    0xFFff0055,
    const <int, Color>{
      50: const Color(0xFFff4081),
      100: const Color(0xFFff4081),
      200: const Color(0xFFff4081),
      300: const Color(0xFFff4081),
      400: const Color(0xFFff4081),
      500: const Color(0xFFff4081),
      600: const Color(0xFFff4081),
      700: const Color(0xFFff4081),
      800: const Color(0xFFff4081),
      900: const Color(0xFFff4081),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0.0,
        title: Center(
          child: Text(
            'Welcome to LocalMart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/background.jpg'),
            fit: BoxFit.contain,
            matchTextDirection: true,
          ),
          //   // gradient: LinearGradient(
          //   //   begin: Alignment.topLeft,
          //   //   end: Alignment.bottomRight,
          //   //   colors: [
          //   //     Color(0xFFf45d27),
          //   //     Color(0xFFff4081)
          //   //   ],
          //   // ),
        ),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              // Container(
              //   alignment: Alignment.center,
              //   child: Text('Want to Continue As...'),
              // ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset('Images/Customer.jpg'),
                      ),
                      //child: Icon(Icons.android, size: 80, color: darkMode ? Colors.white : Colors.black),
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     begin: Alignment.topLeft,
                      //     end: Alignment.bottomRight,
                      //     colors: [
                      //       Color(0xFFFFFFFF),
                      //       Color(0xFFFFFFFF)
                      //     ],
                      //   ),
                      // ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          //: Colors.white,
                          child: Text(
                            'Customer',
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => CusLogin()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40),
              Text(
                'OR',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset('Images/Owner.jpg'),
                          ),
                          // decoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     begin: Alignment.topLeft,
                          //     end: Alignment.bottomRight,
                          //     colors: [
                          //       Color(0xFFf45d27),
                          //       Color(0xFFff4081)
                          //     ],
                          //   ),
                          // ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: [
                            ElevatedButton(
                              //color: Colors.white,
                              child: Text(
                                'Retailer',
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => RetailLogin(User)),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
