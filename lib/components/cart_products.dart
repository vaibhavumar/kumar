import 'package:flutter/material.dart';

class CartProducts extends StatefulWidget {
  @override
  _CartProductsState createState() => _CartProductsState();
}

class _CartProductsState extends State<CartProducts> {
  var productsOnTheCart = [
    {
      "name": "Blended Tea",
      "picture": "images/banner/Georgia.jpg",
      "price": 100.0,
      "quantity": 1,
    },
    {
      "name": "Tea",
      "picture": "images/banner/Georgia.jpg",
      "price": 100.0,
      "quantity": 4,
    },
    {
      "name": "Double Blended Tea",
      "picture": "images/banner/Georgia.jpg",
      "price": 100.0,
      "quantity": 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productsOnTheCart.length,
      itemBuilder: (context, index) {
        return SingleCartProduct(
          cartProductName: productsOnTheCart[index]["name"],
          cartProductPicture: productsOnTheCart[index]["picture"],
          cartProductPrice: productsOnTheCart[index]["price"],
          cartProductQuantity: productsOnTheCart[index]["quantity"],
        );
      },
    );
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
        leading: Image.asset(
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
