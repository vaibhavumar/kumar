import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../db/users.dart';
import 'package:kumar/pages/login/auth.dart';
import 'package:kumar/pages/drawer/home.dart';
import 'package:kumar/pages/login/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  bool hidePass = true;
  FirebaseAuth fireBaseAuth = FirebaseAuth.instance;
  UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    await fireBaseAuth.currentUser().then((user) {
      if (user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

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
                            child: ListTile(
                              title: TextFormField(
                                obscureText: hidePass,
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
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                ),
                                onPressed: () {
                                  setState(() {
                                    hidePass = !hidePass;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(18.0),
                          color: Colors.deepOrange.withOpacity(0.9),
                          elevation: 0.0,
                          child: MaterialButton(
                            onPressed: () {
                              validateForm();
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text("Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Text("other login options:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.0, color: Colors.white)),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GoogleSignInButton(
                    onPressed: () {},
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text("Register Now",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 20.0)),
                  ))
            ],
          ),

          Visibility(
            visible: authService.loading ?? true,
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

  void validateForm() {
    if (_formKey.currentState.validate()) {
      fireBaseAuth
          .signInWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text)
          .then((user) {
        userServices.setUserData(user.uid);
      }).catchError((error) {
        var errorCode = error.code;
        var errorMessage = error.message;
        if (errorMessage ==
            'There is no user record corresponding to this identifier. The user may have been deleted.') {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('No User'),
                  content: Text('"${_emailTextController.text}" not found'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignUp()));
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person_add),
                          Text('Sign up')
                        ],
                      ),
                    )
                  ],
                );
              });
        } else if (errorCode == 'auth/wrong-password') {
          Fluttertoast.showToast(msg: 'Wrong password');
        } else {
          Fluttertoast.showToast(msg: errorMessage);
        }
      }).whenComplete(() {
        isSignedIn();
      });
    }
  }
}
