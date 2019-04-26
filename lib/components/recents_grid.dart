import 'package:flutter/material.dart';

import 'package:kumar/pages/product_details.dart';

class RecentProducts extends StatefulWidget {
  @override
  _RecentProductsState createState() => _RecentProductsState();
}

class _RecentProductsState extends State<RecentProducts> {
  var productList = [
    {
      "name": "Blended Tea",
      "picture": "images/banner/Georgia.jpg",
      "old price": 120.0,
      "price": 100.0,
    },
    {
      "name": "Tea",
      "picture": "images/banner/Georgia.jpg",
      "old price": 120.0,
      "price": 100.0,
    },
    {
      "name": "Double Blended Tea",
      "picture": "images/banner/Georgia.jpg",
      "old price": 120.0,
      "price": 100.0,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      primary: true,
      shrinkWrap: true,
      itemCount: productList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return SingleProduct(
          productName: productList[index]["name"],
          productPicture: productList[index]["picture"],
          productOldPrice: productList[index]["old price"],
          productPrice: productList[index]["price"],
        );
      },
    );
  }
}

class SingleProduct extends StatelessWidget {
  final productName;
  final productPicture;
  final productOldPrice;
  final productPrice;

  SingleProduct({
    this.productName,
    this.productPicture,
    this.productOldPrice,
    this.productPrice,
  });

  Widget _buildChild(){
    if(productOldPrice != 0){
      final discount = (productOldPrice - productPrice)/productOldPrice * 100;
      return Text('${discount.toStringAsFixed(2)}\% off', textAlign: TextAlign.right, style: TextStyle(color: Colors.white));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //=======Grid Products========
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        //=======Page Routing======
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          //=======Passing values to ProductDetails=======
            builder: (context) => ProductDetails(
                  productDetailName: productName,
                  productDetailPicture: productPicture,
                  productDetailOldPrice: productOldPrice,
                  productDetailPrice: productPrice,
                ))),
        //====End of Routing=====
        child: GridTile(
          header: Container(
            color: Colors.deepOrange.withOpacity(0.8),
            child: _buildChild(),
          ),
          footer: Container(
            color: Colors.white70,
            child: Row(children: <Widget>[
              Expanded(child: Text(productName, style: TextStyle(fontWeight: FontWeight.bold),),),
              Column(children: <Widget>[
              Text("₹$productOldPrice", style: TextStyle(decoration: TextDecoration.lineThrough),),
              Text("₹$productPrice", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
              ],),
            ],),
            // child: ListTile(
            //   //========Product Name and Price========
            //   leading: Text(product_name,
            //       style: TextStyle(fontWeight: FontWeight.bold),),
            //   title: Text(
            //     '₹$product_price',
            //     style: TextStyle(
            //         color: Colors.red, fontWeight: FontWeight.w800),
            //   ),
            //   subtitle: Text(
            //     '₹$product_old_price',
            //     style: TextStyle(
            //         color: Colors.black,
            //         decoration: TextDecoration.lineThrough,
            //         fontWeight: FontWeight.w800),
            //   ),
            // ),
          ),
          //=======Product Image=========
          child: Image.asset(
            productPicture,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
