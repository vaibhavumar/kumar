import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerServices {
  Firestore _firestore = Firestore.instance;
  Future<List<NetworkImage>> getImages() async {
    List<NetworkImage> images = List<NetworkImage>();
    QuerySnapshot querySnaps =
        await _firestore.collection('banners').getDocuments();
    for (DocumentSnapshot document in querySnaps.documents) {
      images.add(NetworkImage(document.data['image']));
    }
    return images;
  }
}
