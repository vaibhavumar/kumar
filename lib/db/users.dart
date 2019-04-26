import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  Firestore _firestore = Firestore.instance;
  String ref = "users";

  createUser(Map<String,dynamic> value) {
    String id = value["userId"];
    _firestore.collection('users').document(id).setData(value).catchError((e){
      print(e.toString());
    });
  }
  Future<Map<String, dynamic>> getUserData(String uid) async {
    Map<String, dynamic> user = Map<String, dynamic>();
    await _firestore.collection('users').document(uid).get().then((snapshot){
      user['username'] = snapshot['username'];
    });
    return user;
  }
}
