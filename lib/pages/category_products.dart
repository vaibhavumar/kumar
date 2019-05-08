import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kumar/components/searchProduct.dart';

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
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(widget.categoryName));
              }),
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
                itemBuilder: (context, index) => BuildProduct(
                    context: context,
                    document: snapshots.data.documents[index],
                    searchDelegate: null));
          }),
    );
  }
}
