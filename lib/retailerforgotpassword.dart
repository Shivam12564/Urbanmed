import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urbanmed/constant.dart';
import 'package:urbanmed/loading.dart';

class Forgetpassword extends StatefulWidget {

  @override
  Fpassword createState() => Fpassword();
}

class Fpassword extends State<Forgetpassword> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController = TextEditingController();
  String error = '';
  bool loading = false;
  String? email;
  final auth = FirebaseAuth.instance;


  String? password;
  @override
  initState() {
    emailInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        elevation: 0.0,
        title: Text('Forgot Password ?'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) =>val != null &&  val.isEmpty ? 'Enter your Email ' : null,
                controller: emailInputController,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  //color: Colors.cyan,
                  child: Text(
                    'Submit',
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
                    if(_formKey.currentState!.validate()){
                      setState(() => loading = true);
                      auth.sendPasswordResetEmail(email: email!);
                      Navigator.of(context).pop();
                      //dynamic customerresult = await _auth.customerregister(fullname, address, contact, email, password);
                    }
                  }
              ),
              /*SizedBox(height: 12.0),
              ElevatedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Back to Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      //dynamic customerresult = await _auth.customerregister(fullname, address, contact, email, password);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RetailLogin(),
                      ),);
                    }
                  }
              ),*/
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}