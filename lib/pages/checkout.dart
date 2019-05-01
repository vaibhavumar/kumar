import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/addresses.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool isPlaceDisabled = false;
  String userId;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;
  int _radioGroup = 0;

  @override
  void initState() {
    super.initState();
    firebaseAuth.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
  }

  disablePlace() async {
    setState(() {
      isPlaceDisabled = !isPlaceDisabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Checkout'),
        elevation: 0.0,
      ),
      body: StreamBuilder(
          stream: firestore
              .collection('users')
              .document(userId)
              .collection('address')
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            if (snapshots.data.documents.length == 0) {
              disablePlace();
              return Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('No Address Registered'),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Addresses()));
                        },
                        child: Text('Add New Address'),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildAddress(
                        snapshots.data.documents, index, _radioGroup);
                  });
            }
          }),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: isPlaceDisabled ? Colors.black54 : Colors.red,
                      width: 5.0,
                      style: BorderStyle.solid)),
              child: RaisedButton(
                disabledColor: Colors.grey,
                color: Colors.deepOrange,
                elevation: 10.0,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                onPressed: isPlaceDisabled ? null : () {},
                child: Text('Place Order'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddress(document, int index, _radioGroup) {
    String name = document[index]['reciever'];
    String address = document[index]['address'];
    bool isDefault = document[index]['isDefault'];
    return Card(
      elevation: 2.0,
      child: ListTile(
          leading: Radio<int>(
            value: index,
            groupValue: _radioGroup,
            onChanged: _handleRadioValueChange,
          ),
          trailing: isDefault ? Text('Default') : null,
          title: Text(name),
          subtitle: Text(address)),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioGroup = value;
      print(_radioGroup);
    });
  }
}
