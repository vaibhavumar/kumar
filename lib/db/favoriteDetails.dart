import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoriteDetails {
  Firestore _fireStore = Firestore.instance;

  Future<List<dynamic>> getFavorites() async {
    List<dynamic> favorites;

    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    QuerySnapshot querySnaps = await _fireStore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .getDocuments();
    favorites = querySnaps.documents.first.data['favorite'];
    return favorites ?? [];
  }

  Future<bool> alreadyInFavorites(String productId) async {
    List<dynamic> favorites = await getFavorites();
    if (favorites.isNotEmpty) {
      if (favorites.contains(productId))
        return true;
      else
        return false;
    } else
      return false;
  }

  void removeProductFromFavorites(String productId) async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    _fireStore.collection('users').document(userId).updateData({
      'favorite': FieldValue.arrayRemove([productId])
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void addProductToFavorites(String productId) async {
    await FirebaseAuth.instance.currentUser().then((user) {
      _fireStore.collection('users').document(user.uid).updateData({
        'favorite': FieldValue.arrayUnion([productId])
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    });
  }
}
