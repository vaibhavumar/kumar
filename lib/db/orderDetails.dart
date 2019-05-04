import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetails {
  Firestore _fireStore = Firestore.instance;

  Future<List<dynamic>> getOrders() async {
    List<dynamic> orders;

    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    QuerySnapshot querySnaps = await _fireStore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .getDocuments();
    orders = querySnaps.documents.first.data['orders'];
    return orders ?? [];
  }

  void cancelOrder(String orderId) async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    _fireStore.collection('users').document(userId).updateData({
      'orders': FieldValue.arrayRemove([orderId])
    }).then((_) {
      Fluttertoast.showToast(msg: 'Order Cancelled');
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void addOrder(String orderId) async {
    await FirebaseAuth.instance.currentUser().then((user) {
      _fireStore.collection('users').document(user.uid).updateData({
        'orders': FieldValue.arrayUnion([orderId])
      }).then((_) {
        Fluttertoast.showToast(msg: 'Order Placed');
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    });
  }
}
