import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../pages/category_products.dart';

class HorizontalListCategories extends StatefulWidget {
  @override
  _HorizontalListCategoriesState createState() =>
      _HorizontalListCategoriesState();
}

class _HorizontalListCategoriesState extends State<HorizontalListCategories> {
  Firestore _storage = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        child: StreamBuilder(
          stream: _storage.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => Categories(
                    imageCaption: snapshot.data.documents[index]
                        ['categoryName'],
                    imageLocation: snapshot.data.documents[index]['image'],
                  ),
            );
          },
        ));
  }
}

class Categories extends StatelessWidget {
  final String imageLocation;
  final String imageCaption;

  Categories({this.imageLocation, this.imageCaption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10.8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(width: 1.5)),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CategoryBasedProducts(categoryName: imageCaption)));
          },
          child: Container(
            width: 200.0,
            child: ListTile(
              title: Image.network(
                imageLocation,
                height: 120.0,
                width: double.infinity,
              ),
              subtitle: Container(
                  alignment: Alignment.topCenter, child: Text(imageCaption)),
            ),
          ),
        ),
      ),
    );
  }
}
