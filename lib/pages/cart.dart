import 'package:flutter/material.dart';
import '../db/cartDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkout.dart';

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

      body: CartProducts(totalCost: totalCost),

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
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => CheckOut()));
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
}

class CartProducts extends StatefulWidget {
  var totalCost;

  CartProducts({
    this.totalCost,
  });

  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  CartDetails cartDetails = CartDetails();
  List<dynamic> cart;
  Firestore _firestore = Firestore.instance;
  static var productsOnTheCart = [];

  @override
  void initState() {
    super.initState();
    getCart();
  }

  @override
  void dispose() {
    widget.totalCost = 0.0;
    productsOnTheCart.clear();
    super.dispose();
  }

  void updateTotal(double sellingPrice) async {
    setState(() {
      widget.totalCost += sellingPrice;
    });
  }

  void getCart() async {
    cart = await cartDetails.getCart();
    for (String productId in cart) {
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
    return ListView.builder(
        itemCount: productsOnTheCart.length,
        itemBuilder: (context, index) {
          double costPrice =
              double.parse(productsOnTheCart[index]['costPrice']);
          double discount = double.parse(productsOnTheCart[index]['discount']);
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
