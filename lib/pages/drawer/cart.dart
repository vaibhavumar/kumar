import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumar/db/cartDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kumar/pages/checkout.dart';

// ignore: must_be_immutable
class InheritedCart extends InheritedWidget {
  bool hasProducts = false;

  InheritedCart({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static InheritedCart of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedCart);
}

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  double totalCost = 0.0;
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
                subtitle: Text("₹$totalCost"),
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  _handleCheckout();
                },
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

  _handleCheckout() {
    if (InheritedCart.of(context).hasProducts)
      Navigator.push(context, MaterialPageRoute(builder: (_) => CheckOut()));
    else
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('add Products to Cart first'),
              ));
  }
}

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  CartDetails cartDetails = CartDetails();
  Firestore _firestore = Firestore.instance;
  static var productsOnTheCart = [];
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String userId;

  @override
  void didUpdateWidget(CartProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    productsOnTheCart.clear();
    getCart();
  }

  @override
  void initState() {
    super.initState();
    getCart();
  }

  @override
  void dispose() {
    productsOnTheCart.clear();
    super.dispose();
  }

  void updateTotal(double sellingPrice) async {
    setState(() {
//      widget.totalCost += sellingPrice;
    });
  }

  void getCart() async {
    for (String productId in await cartDetails.getCart()) {
      QuerySnapshot snaps = await _firestore
          .collection('products')
          .where('id', isEqualTo: productId)
          .getDocuments();
      Map<String, dynamic> productDetail = snaps.documents.first.data;
      setState(() {
        productsOnTheCart.add(productDetail);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (productsOnTheCart.isEmpty) {
      setState(() {
        InheritedCart.of(context).hasProducts = false;
      });
      return Center(
        child: Text('No Products in Cart'),
      );
    }
    setState(() {
      InheritedCart.of(context).hasProducts = true;
    });
    return ListView.builder(
        itemCount: productsOnTheCart.length,
        itemBuilder: (context, index) {
          double costPrice =
              double.parse(productsOnTheCart[index]['costPrice'].toString());
          double discount =
              double.parse(productsOnTheCart[index]['discount'].toString());
          var sellingPrice = costPrice - (costPrice * (discount / 100));
          //updateTotal(sellingPrice);
          return SingleCartProduct(
            cartProductName: productsOnTheCart[index]['name'],
            cartProductPicture: productsOnTheCart[index]["image"],
            cartProductPrice: sellingPrice.toString(),
            cartProductQuantity: '1',
          );
        });
  }
}

class SingleCartProduct extends StatelessWidget {
  final cartProductName;
  final cartProductPicture;
  final cartProductPrice;
  final cartProductQuantity;

  SingleCartProduct({
    this.cartProductName,
    this.cartProductPicture,
    this.cartProductPrice,
    this.cartProductQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        //====Product Image=====
        leading: Image.network(
          cartProductPicture,
          width: 60.0,
          height: 60.0,
        ),
        //===Product Name====
        title: Text(cartProductName),
        //===Price, Quantity=====
        subtitle: Column(
          // ==== Column -> Row =======
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Quantity:"),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(1.0),
            //       child: Text(
            //         "${cart_product_quantity}",
            //         style: TextStyle(color: Colors.red),
            //       ),
            //     ),
            //   ],
            // ),
            //======Product Price======
            Text(
              "₹$cartProductPrice",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),

        //=====
        trailing: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_drop_up),
                onPressed: () {},
              ),
              Text("$cartProductQuantity"),
              IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
