import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Addresses extends StatefulWidget {
  @override
  _AddressesState createState() => _AddressesState();
}

class _AddressesState extends State<Addresses> {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userId;

  @override
  void initState() {
    super.initState();
    getUser();
    print(userId);
  }

  void getUser() async {
    firebaseAuth.currentUser().then((user) {
      setState(() {
        userId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrangeAccent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text('Address'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            padding: EdgeInsets.all(8.0),
            child: ListView(scrollDirection: Axis.vertical, children: [
              StreamBuilder(
                  stream: _firestore
                      .collection('users')
                      .document(userId)
                      .collection('address')
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData)
                      return Center(child: CircularProgressIndicator());
                    if (snapshots.data.documents.length == 0) {
                      print(userId);
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                            child: Text(
                          'No address',
                          style: TextStyle(
                              color: Colors.deepOrange, fontSize: 20.0),
                        )),
                      );
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (context, index) {
                          return _buildList(snapshots.data.documents, index);
                        });
                  }),
              OutlineButton(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                onPressed: () {
                  var alert = MyDialog(
                    userId: userId,
                  );
                  showDialog(context: this.context, child: alert).then((_) {
                    setState(() {});
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Add New Address',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  Widget _buildList(List<DocumentSnapshot> document, int index) {
    String name = document[index]['reciever'];
    String address = document[index]['address'];
    bool isDefault = document[index]['isDefault'];
    DocumentReference ref = document[index].reference;
    return Card(
      elevation: 2.0,
      child: ExpansionTile(
        trailing: isDefault ? Text('Default') : null,
        title: Text(name),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 14.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Address',
                  style: TextStyle(color: Colors.deepOrange, fontSize: 10.0),
                ),
                Text(address)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    //TODO: Edit Address
//                    var alert = MyModifyDialog(
//                      userId: userId,
//                      name: name,
//                      address: address,
//                      isDefault: isDefault,
//                      ref: ref,
//                    );
//                    showDialog(context: this.context, child: alert);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.edit),
                      Text('Edit'),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  final userId;
  MyDialog({
    this.userId,
  });
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> _addKey;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    _addKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _addKey.currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add address'),
      titleTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      backgroundColor: Colors.deepOrangeAccent,
      content: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
              key: _addKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Name cannot be empty';
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 10,
                    decoration: InputDecoration(hintText: 'Address'),
                    validator: (value) {
                      if (value.isEmpty) return 'Address cannot be empty';
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: isDefault,
                          onChanged: (value) {
                            setState(() {
                              isDefault = value;
                            });
                          }),
                      Text('Default Address')
                    ],
                  )
                ],
              )),
        ),
      ),
      contentPadding: EdgeInsets.all(10.0),
      actions: <Widget>[
        FlatButton(
          onPressed: _addAddress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.close,
                color: Colors.white,
              ),
              Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  _addAddress() {
    if (_addKey.currentState.validate()) {
      Firestore.instance
          .collection('users')
          .document(widget.userId)
          .collection('address')
          .add({
        'reciever': _nameController.text,
        'address': _addressController.text,
        'isDefault': isDefault,
      }).then((value) {
        Fluttertoast.showToast(msg: 'Address Added.');
        _addKey.currentState.reset();
        Navigator.pop(context);
      }).catchError((err) {
        Fluttertoast.showToast(msg: 'ERROR:' + err.toString());
      });
    }
  }
}

class MyModifyDialog extends StatefulWidget {
  final userId;
  final String name;
  final String address;
  final bool isDefault;
  final ref;
  MyModifyDialog(
      {this.userId,
      this.name = '',
      this.address = '',
      this.isDefault = false,
      this.ref});
  @override
  _MyModifyDialogState createState() => _MyModifyDialogState();
}

class _MyModifyDialogState extends State<MyModifyDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  GlobalKey<FormState> _addKey;
  bool isDefault;

  @override
  void initState() {
    super.initState();
    isDefault = widget.isDefault;
    _nameController.text = widget.name;
    _addressController.text = widget.address;
    _addKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _addKey.currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add address'),
      titleTextStyle:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      backgroundColor: Colors.deepOrangeAccent,
      content: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
              key: _addKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Name cannot be empty';
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 10,
                    decoration: InputDecoration(hintText: 'Address'),
                    validator: (value) {
                      if (value.isEmpty) return 'Address cannot be empty';
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          value: isDefault,
                          onChanged: (value) {
                            setState(() {
                              isDefault = value;
                            });
                          }),
                      Text('Default Address')
                    ],
                  )
                ],
              )),
        ),
      ),
      contentPadding: EdgeInsets.all(10.0),
      actions: <Widget>[
        FlatButton(
          onPressed: _modifyAddress(widget.ref),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.close,
                color: Colors.white,
              ),
              Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }

  _modifyAddress(DocumentReference ref) {
    if (_addKey.currentState.validate())
      Firestore.instance
          .collection('users')
          .document(widget.userId)
          .collection('address')
          .document(ref.documentID)
          .setData({
        'reciever': _nameController.text,
        'address': _addressController.text,
        'isDefault': isDefault,
      }).then((value) {
        Fluttertoast.showToast(msg: 'Address Modified.');
        _addKey.currentState.reset();
        Navigator.pop(context);
      }).catchError((err) {
        Fluttertoast.showToast(msg: 'ERROR:' + err.toString());
      });
  }
}
