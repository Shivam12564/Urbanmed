//code run karavano chhe pachi agad nu edit karvanu chhe

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/customer_registration.dart';
import 'commons.dart';
import 'customer_dashboard.dart';
import 'customerforgotpassword.dart';

class CusLogin extends StatefulWidget {
  @override
  CLogin createState() => CLogin();
}

class CLogin extends State<CusLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  initState() {
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0.0,
        title:
           Text(
            'Welcome to Urbanmed',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('Images/Customer.jpg'),
                  ),),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                      textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val != null && val.isEmpty ? 'Enter an email' : null,
                      controller: emailInputController,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration:
                      textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) =>val != null &&  val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      controller: passwordInputController,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                            'Forgot Password ?',
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Forgetpassword()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                        //color: Colors.cyan,
                        child: Text(
                          'Log In',
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
                        onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: emailInputController.text,
                                    password: passwordInputController.text);

                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                await prefs.setBool('islogin', true);
                                await prefs.setString('type', 'customer');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerDashboard(),
                                  ),
                                );
                              } catch (e) {
                                showMyDialog(context, 'Error!!', e.toString());
                              }
                            }

                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 12.0),
                    new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Cusregister(),
                        ));
                      },
                      child: new Text("New to UrbanMed !! Click here"),
                    )
                  ],
                ),
              ),
            ),
            // Padding(
            //   //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
            //   padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: TextField(
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'Email',
            //         hintText: 'Enter valid email id as abc@gmail.com'),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 15.0, right: 15.0, top: 15, bottom: 0),
            //   //padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: TextField(
            //     obscureText: true,
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'Password',
            //         hintText: 'Enter secure password'),
            //   ),
            // ),
            // FlatButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //           builder: (context) => Forgetpassword()),
            //     );
            //   },
            //   child: Text(
            //     'Forgot Password',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            // Container(
            //   height: 50,
            //   width: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            //   child: FlatButton(
            //     onPressed: () async {
            //       if (_formKey.currentState.validate()) {
            //         setState(() => loading = true);
            //         try {
            //           await FirebaseAuth.instance
            //               .signInWithEmailAndPassword(
            //               email: emailInputController.text,
            //               password: passwordInputController.text);
            //
            //           SharedPreferences prefs =
            //               await SharedPreferences.getInstance();
            //           await prefs.setBool('islogin', true);
            //           await prefs.setString('type', 'customer');
            //           Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => CustomerDashboard(),
            //             ),
            //           );
            //         } catch (e) {
            //           showMyDialog(context, 'Error!!', e.message);
            //         }
            //       }
            //     },
            //     child: Text(
            //       'Login',
            //       style: TextStyle(color: Colors.white, fontSize: 25),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 130,
            // ),
            // new GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //       builder: (context) => Cusregister(),
            //     ));
            //   },
            //   child: new Text("New to UrbanMed !! Click here"),
            // )
          ],
        ),
      ),
    );
  }
}
