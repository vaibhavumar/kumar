import 'package:flutter/material.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  bool isPlaceDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Checkout'),
        elevation: 2.0,
      ),
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
}
