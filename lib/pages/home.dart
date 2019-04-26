import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

//=====My Packages=======
import 'package:kumar/components/horizontal_list.dart';
import 'package:kumar/components/recents_grid.dart';
import 'package:kumar/pages/cart.dart';
import 'package:kumar/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    SharedPreferences temp = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences = temp;
    });
  }

  createDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          //========Header===========
          UserAccountsDrawerHeader(
            accountName: Text('test'),
            accountEmail: Text('test'),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.orange),
          ),

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
                color: Colors.orange,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: ListTile(
              title: Text('My Account'),
              leading: Icon(
                Icons.person,
                color: Colors.orange,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShoppingCart()));
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
            onTap: () {},
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //=============Carousel================
    Widget imageCarousel = Container(
      height: 300.0,
      child: Carousel(
        boxFit: BoxFit.contain,
        images: [
          AssetImage('images/banner/cavin.jpg'),
          AssetImage('images/banner/cavins-milkshake-500x500.jpg'),
          AssetImage('images/banner/Georgia.jpg'),
          AssetImage('images/banner/vio.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text('Kumar'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShoppingCart()));
                })
          ],
          elevation: 0.0,
        ),
        drawer: createDrawer(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
                  child: Stack(
            children: <Widget>[
              //=======Carousel===========
              ClipPath(
                clipper: GetClipper(),
                child: imageCarousel,
              ),
              // //=======Horizontal List Categories====
              Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: HorizontalListCategories(),
                  ),
              Padding(
                padding: const EdgeInsets.only(top:400.0),
                child: RecentProducts(),
              ),
            ],
          ),
        ),
      ),
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

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width + 400, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
