import 'package:flutter/material.dart';

import 'package:kumar/components/cart_products.dart';

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Shopping Cart'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
        elevation: 0.3,
      ),

      body: CartProducts(),

      //======Total Checkout==========
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text("Total:"),
                subtitle: Text("₹1232"),
              ),
            ),
            Expanded(
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepOrange,
              ),
            )
          ],
        ),
      ),
    );
  }
}
