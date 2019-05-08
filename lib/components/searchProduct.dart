import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kumar/pages/product_details.dart';

class BuildProduct extends StatelessWidget {
  final double costPrice;
  final double discount;
  final productName;
  final productImage;
  final productQuantity;
  final BuildContext context;
  final DocumentSnapshot document;
  final CustomSearchDelegate searchDelegate;

  BuildProduct(
      {BuildContext context,
      DocumentSnapshot document,
      CustomSearchDelegate searchDelegate})
      : costPrice = double.parse(document['costPrice'].toString()),
        discount = double.parse(document['discount'].toString()),
        productName = document['name'],
        productImage = document['image'],
        productQuantity = document['quantity'],
        context = context,
        document = document,
        searchDelegate = searchDelegate;

  @override
  Widget build(BuildContext context) {
    final sellingPrice = costPrice - (costPrice * (discount / 100));
    return Card(
      child: InkWell(
        onTap: () {
          searchDelegate.close(context, null);
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

class CustomSearchDelegate extends SearchDelegate {
  final String categoryName;

  CustomSearchDelegate(this.categoryName);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return categoryName == null
        ? StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('products').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> querySnap) {
              if (!querySnap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final results = querySnap.data.documents.where((doc) =>
                  doc['name']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()));
              return ListView.builder(
                itemCount: results.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return BuildProduct(
                      context: context,
                      document: results.elementAt(index),
                      searchDelegate: this);
                },
              );
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('products')
                .where('category', isEqualTo: categoryName)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> querySnap) {
              if (!querySnap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final results = querySnap.data.documents.where((doc) =>
                  doc['name']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()));
              return ListView.builder(
                itemCount: results.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return BuildProduct(
                      context: context,
                      document: results.elementAt(index),
                      searchDelegate: this);
                },
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return categoryName == null
        ? StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('products').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> querySnap) {
              if (!querySnap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (query.isNotEmpty) {
                final results = querySnap.data.documents.where((doc) =>
                    doc['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()));
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: results
                      .map<ListTile>((document) => ListTile(
                            title: Text(document['name']),
                            onTap: () {
                              query = document['name'];
                              showResults(context);
                            },
                          ))
                      .toList(),
                );
              }
              return Center(
                child: Text('Search products in All Categories'),
              );
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('products')
                .where('category', isEqualTo: categoryName)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> querySnap) {
              if (!querySnap.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (query.isNotEmpty) {
                final results = querySnap.data.documents.where((doc) =>
                    doc['name']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()));
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: results
                      .map<ListTile>((document) => ListTile(
                            title: Text(document['name']),
                            onTap: () {
                              query = document['name'];
                              showResults(context);
                            },
                          ))
                      .toList(),
                );
              }
              return Center(
                child: Text('Search products in $categoryName'),
              );
            },
          );
  }
}
