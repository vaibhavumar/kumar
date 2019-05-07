import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details.dart';

class CategoryBasedProducts extends StatefulWidget {
  final categoryName;
  CategoryBasedProducts({this.categoryName});
  @override
  _CategoryBasedProductsState createState() => _CategoryBasedProductsState();
}

class _CategoryBasedProductsState extends State<CategoryBasedProducts> {
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('${widget.categoryName}'),
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
      body: StreamBuilder(
          stream: _firestore
              .collection('products')
              .where('category', isEqualTo: widget.categoryName)
              .snapshots(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) return CircularProgressIndicator();
            return ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, index) => _buildProducts(
                      context,
                      snapshots.data.documents[index],
                    ));
          }),
    );
  }

  _buildProducts(BuildContext context, DocumentSnapshot document) {
    final double costPrice = double.parse(document['costPrice'].toString());
    final double discount = double.parse(document['discount'].toString());
    final double sellingPrice = costPrice - (costPrice * (discount / 100));
    final productName = document['name'];
    final productImage = document['image'];
    final productQuantity = document['quantity'];
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetails(
                        productDetailId: document['id'],
                        productDetailCategory: document['category'],
                        productDetailName: productName,
                        productDetailOldPrice: costPrice,
                        productDetailPicture: productImage,
                        productDetailPrice: sellingPrice,
                        productDetailQuantity: productQuantity,
                      )));
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(20.0),
          //====Product Image=====
          leading: Stack(children: [
            Image.network(
              productImage,
              width: 80.0,
              height: 80.0,
            ),
            discount == 0.0
                ? SizedBox(
                    width: 0.1,
                  )
                : Container(
                    color: Colors.black87,
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      '$discount% Off',
                      style:
                          TextStyle(color: Colors.deepOrange, fontSize: 16.0),
                    ),
                  ),
          ]),
          //===Product Name====
          title: Text('$productName'),
          //===Price, Quantity=====
          subtitle: Column(
            // ==== Column -> Row =======
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Quantity:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      "$productQuantity",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              //======Product Price======
//            Text(
//              "₹$cartProductPrice",
//              style: TextStyle(
//                  color: Colors.red,
//                  fontSize: 16.0,
//                  fontWeight: FontWeight.bold),
//            ),
            ],
          ),

          //=====Price and Discounted Price
          trailing: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Text(
                  '₹$costPrice',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red),
                ),
                Text(
                  '₹${sellingPrice.round()}',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
