import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumar/db/users.dart';
import 'package:kumar/pages/drawer/cart.dart';
import 'package:kumar/pages/drawer/favorites.dart';
import 'package:kumar/pages/drawer/home.dart';
import 'package:kumar/pages/drawer/myorder.dart';
import 'package:kumar/pages/login/login.dart';
import 'package:kumar/pages/drawer/myaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  UserServices userServices = UserServices();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences sharedPreferences;

  String username;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListView(
      children: <Widget>[
        SizedBox(
          height: height * 0.2,
        ),
        //========Header===========
//        UserAccountsDrawerHeader(
//          accountName: FutureBuilder(
//              future: userServices.getUserData('username'),
//              builder: (context, userData) {
//                username = userData.data;
//                return userData.hasData
//                    ? Text('${userData.data}')
//                    : Text('null');
//              }),
//          accountEmail: FutureBuilder(
//              future: userServices.getUserData('email'),
//              builder: (context, userData) {
//                return userData.hasData
//                    ? Text('${userData.data}')
//                    : Text('null');
//              }),
//          currentAccountPicture: GestureDetector(
//            child: CircleAvatar(
////                backgroundColor: Colors.grey,
//              child: Icon(
//                Icons.person,
//                color: Colors.white,
//              ),
//            ),
//          ),
////            decoration: BoxDecoration(color: Colors.orange),
//        ),

        //========BODY============
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: ListTile(
            title: Text('Home'),
            leading: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MyAccount(username: username)));
          },
          child: ListTile(
            title: Text('My Account'),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MyOrders()));
          },
          child: ListTile(
            title: Text('My Orders'),
            leading: Icon(
              Icons.shopping_basket,
              color: Colors.orange,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InheritedCart(child: ShoppingCart())));
          },
          child: ListTile(
            title: Text('Shopping Cart'),
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => FavoritePage()));
          },
          child: ListTile(
            title: Text('Favourites'),
            leading: Icon(
              Icons.favorite,
              color: Colors.orange,
            ),
          ),
        ),
        Divider(),
        InkWell(
          onTap: () {},
          child: ListTile(
            title: Text('Settings'),
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            title: Text('About'),
            leading: Icon(
              Icons.help,
              color: Colors.blue,
            ),
          ),
        ),
        InkWell(
          onTap: userLogout,
          child: ListTile(
            title: Text('Logout'),
            leading: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  void userLogout() async {
    await _firebaseAuth.signOut().whenComplete(() {
      sharedPreferences.clear();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }
}
