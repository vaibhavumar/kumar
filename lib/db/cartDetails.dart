import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartDetails {
  Firestore _firestore = Firestore.instance;

  Future<List<dynamic>> getCart() async {
    List<dynamic> cart;

    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    QuerySnapshot querySnaps = await _firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .getDocuments();
    cart = querySnaps.documents.first.data['cart'];
    return cart ?? [];
  }

  Future<bool> alreadyInCart(String productId) async {
    List<dynamic> cart = await getCart();
    if (cart.isNotEmpty) {
      if (cart.contains(productId))
        return true;
      else
        return false;
    } else
      return false;
  }

  void removeProductFromCart(String productId) async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    _firestore.collection('users').document(userId).updateData({
      'cart': FieldValue.arrayRemove([productId])
    }).then((_) {
      Fluttertoast.showToast(msg: 'Removed from Cart.');
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void addProductToCart(String productId) async {
    await FirebaseAuth.instance.currentUser().then((user) {
      _firestore.collection('users').document(user.uid).updateData({
        'cart': FieldValue.arrayUnion([productId])
      }).then((_) {
        Fluttertoast.showToast(msg: 'Added to Cart.');
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    });
  }

  void clearCart() async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    _firestore
        .collection('users')
        .document(userId)
        .updateData({'cart': FieldValue.delete()}).then((_) {
      Fluttertoast.showToast(msg: 'Cart Cleared.');
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }
}
