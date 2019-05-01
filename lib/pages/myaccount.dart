import 'package:flutter/material.dart';
import '../components/addresses.dart';

class MyAccount extends StatefulWidget {
  final username;

  MyAccount({this.username});

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('${widget.username}'),
      ),
      body: Column(
        children: <Widget>[
          Card(
              color: Colors.white,
              elevation: 2.0,
              child: ExpansionTile(
                title: Text('Address'),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: OutlineButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text('Set Default'),
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: OutlineButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Addresses()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.edit),
                              Text('Edit'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
