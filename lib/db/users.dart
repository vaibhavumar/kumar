import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  Firestore _firestore = Firestore.instance;
  String ref = "users";
  SharedPreferences prefs;

  createUser(Map<String, dynamic> value) async {
    prefs = await SharedPreferences.getInstance();
    String id = value["userId"];
    _firestore.collection('users').document(id).setData(value).then((_) {
      prefs.setString('email', value['email']);
      prefs.setString('username', value['username']);
      prefs.setString('userid', id);
    }).catchError((e) {
      print(e.toString());
    });
  }

  setUserData(String uid) async {
    prefs = await SharedPreferences.getInstance();
    await _firestore.collection('users').document(uid).get().then((snapshot) {
      prefs.setString('email', snapshot['email']);
      prefs.setString('username', snapshot['username']);
    });
  }

  Future<String> getUserData(String key) async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'none';
  }
}
