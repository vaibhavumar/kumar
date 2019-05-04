import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kumar/db/cartDetails.dart';
import 'package:kumar/db/orderDetails.dart';
import 'package:kumar/pages/home.dart';

class OrderPage extends StatefulWidget {
  final name;
  final address;

  OrderPage({this.name, this.address});
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Firestore _fireStore = Firestore.instance;
  CartDetails cartDetails = CartDetails();
  OrderDetails orderDetails = OrderDetails();
  List<dynamic> cartItems;

  @override
  void initState() {
    super.initState();
    _getCartItems();
  }

  _getCartItems() async {
    cartItems = await cartDetails.getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Order'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Order will be delivered to:',
                  style:
                      TextStyle(color: Colors.deepOrangeAccent, fontSize: 20.0),
                ),
              ),
            ),
            Card(
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget.name),
              ),
            ),
            Card(
              elevation: 1.5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget.address),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
            ),
            GestureDetector(
              onTap: _handleOrder(widget.name, widget.address),
              child: Container(
                width: 300.0,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(40.0)),
                  color: Colors.deepOrangeAccent,
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Proceed',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            )
          ],
        ));
  }

  _handleOrder(String name, String address) {
    DateTime datetime = DateTime.now();
    String dateId =
        'KUMAR/${datetime.day}${datetime.month}${datetime.year}/${datetime.hour}${datetime.minute}${datetime.second}';
    _fireStore.collection('orders').add({
      'orderId': dateId,
      'name': name,
      'address': address,
      'orders': FieldValue.arrayUnion(cartItems)
    }).then((value) {
      orderDetails.addOrder(dateId);
      cartDetails.clearCart();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    });
  }
}
