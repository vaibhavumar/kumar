import 'package:flutter/material.dart';
import 'package:kumar/components/recents_grid.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Favorites'),
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FavoriteProducts(),
          )),
    );
  }
}
