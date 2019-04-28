import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchServices {
  Firestore _firestore = Firestore.instance;

  Future<List<DocumentSnapshot>> getSuggestion(String suggestion) {
    return _firestore
        .collection('products')
        .where('name', isLessThanOrEqualTo: suggestion)
        .getDocuments()
        .then((snaps) {
      return snaps.documents;
    });
  }

  Future<List<DocumentSnapshot>> getSuggestionByCategory(
      String suggestion, String categoryName) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: categoryName)
        .where('name', isLessThanOrEqualTo: suggestion)
        .getDocuments()
        .then((snaps) {
      return snaps.documents;
    });
  }
}
