import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetails {
  Firestore _fireStore = Firestore.instance;

  Future<Stream<DocumentSnapshot>> getOrders() async {
    String userId = (await FirebaseAuth.instance.currentUser()).uid;
    return _fireStore.collection('users').document(userId).snapshots();
  }

  void addOrder(DocumentReference orderRef) async {
    await FirebaseAuth.instance.currentUser().then((user) {
      _fireStore.collection('users').document(user.uid).updateData({
        'orders': FieldValue.arrayUnion([orderRef])
      }).then((_) {
        Fluttertoast.showToast(msg: 'Order Placed');
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    });
  }
}
