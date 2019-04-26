import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:kumar/db/users.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  UserServices _userServices = UserServices();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmpasswordTextController =
      TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
              child: Image.asset(
            'images/login_bg.jpg',
            fit: BoxFit.fitHeight,
            width: double.infinity,
          )),
          //==========Blur Effect===========
          Container(
            color: Colors.black.withOpacity(0.4),
            width: double.infinity,
            height: double.infinity,
          ),

          ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50.0),
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'images/logo.png',
                  width: 200.0,
                  height: 200.0,
                  color: Colors.deepOrange,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Form(
                  key: _formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                        child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Full Name",
                                  icon: Icon(Icons.person_outline),
                                  border: InputBorder.none,
                                ),
                                controller: _nameTextController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Name field cannot be empty";
                                  } else
                                    return null;
                                },
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.8),
                          elevation: 0.0,
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Email",
                                icon: Icon(Icons.alternate_email),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailTextController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'Please make sure your email address is valid';
                                  else
                                    return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                        child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  icon: Icon(Icons.lock_outline),
                                  border: InputBorder.none,
                                ),
                                controller: _passwordTextController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Password field cannot be empty";
                                  } else if (value.length < 6) {
                                    return "Password must be at least 6 characters long";
                                  } else
                                    return null;
                                },
                              ),
                            )),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                        child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.8),
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  icon: Icon(Icons.lock_outline),
                                  border: InputBorder.none,
                                ),
                                controller: _confirmpasswordTextController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Password field cannot be empty";
                                  } else if (value.length < 6) {
                                    return "Password must be at least 6 characters long";
                                  } else if (_passwordTextController.text !=
                                      value) {
                                    return "Passwords do not match";
                                  } else
                                    return null;
                                },
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Colors.deepOrange.withOpacity(0.9),
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () async {
                              validateForm();
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text("Register",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0)),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),

          Visibility(
            visible: loading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future validateForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      FirebaseUser user = await firebaseAuth.currentUser();
      if (user == null) {
        firebaseAuth
            .createUserWithEmailAndPassword(
                email: _emailTextController.text,
                password: _passwordTextController.text)
            .then((user) => {
                  _userServices.createUser({
                    "username": _nameTextController.text,
                    "email": _emailTextController.text,
                    "userId": user.uid,
                  })
                })
            .catchError((err) => {print(err.toString())});
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
    }
  }
}
