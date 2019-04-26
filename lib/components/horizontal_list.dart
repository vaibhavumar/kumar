import 'package:flutter/material.dart';

class HorizontalListCategories extends StatefulWidget {
  @override
  _HorizontalListCategoriesState createState() =>
      _HorizontalListCategoriesState();
}

class _HorizontalListCategoriesState extends State<HorizontalListCategories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Categories(
            imageLocation: 'images/cats/geargia.png',
            imageCaption: 'Georgia',
          ),
          Categories(
            imageLocation: 'images/cats/geargia.png',
            imageCaption: 'Georgia',
          ),
          Categories(
            imageLocation: 'images/cats/geargia.png',
            imageCaption: 'Georgia',
          ),
          Categories(
            imageLocation: 'images/cats/geargia.png',
            imageCaption: 'Georgia',
          ),
        ],
      ),
    );
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
        elevation: 1.8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(width: 1.5)),
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 200.0,
            child: ListTile(
              title: Image.asset(
                imageLocation,
                width: double.infinity,
                height: 120.0,
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
