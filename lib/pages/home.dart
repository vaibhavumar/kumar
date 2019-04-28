import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kumar/components/horizontal_list.dart';
import 'package:kumar/pages/cart.dart';
import 'package:kumar/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../db/users.dart';
//=====My Packages=======
import 'package:kumar/components/recents_grid.dart';
import '../components/searchBar.dart';
import 'product_details.dart';
import '../db/bannerImages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserServices userServices = UserServices();
  SearchServices _searchServices = SearchServices();
  BannerServices _bannerServices = BannerServices();
  Icon _searchIcon = Icon(Icons.search, color: Colors.white);
  Widget _appBarTitle = Text('Kumar');
  List<NetworkImage> images = List<NetworkImage>();

  @override
  void initState() {
    super.initState();
    getBannerImages();
  }

  createDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          //========Header===========
          UserAccountsDrawerHeader(
            accountName: FutureBuilder(
                future: userServices.getUserData('username'),
                builder: (context, userData) {
                  return userData.hasData
                      ? Text('${userData.data}')
                      : Text('null');
                }),
            accountEmail: FutureBuilder(
                future: userServices.getUserData('email'),
                builder: (context, userData) {
                  return userData.hasData
                      ? Text('${userData.data}')
                      : Text('null');
                }),
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

  searchProducts() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              keyboardType: TextInputType.text,
              cursorColor: Colors.white70,
              autofocus: false,
              decoration: InputDecoration(hintText: 'Search')),
          suggestionsCallback: (pattern) async {
            return await _searchServices.getSuggestion(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Image.network(
                suggestion['image'],
                height: 60.0,
                width: 60.0,
              ),
              title: Text('${suggestion['name']}(${suggestion['quantity']})'),
            );
          },
          onSuggestionSelected: (suggestion) {
            this._searchIcon = Icon(Icons.search);
            this._appBarTitle = Text('Kumar');
            var productPrice = double.parse(suggestion['costPrice']) -
                (double.parse(suggestion['costPrice']) *
                    (double.parse(suggestion['discount']) / 100));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProductDetails(
                          productDetailId: suggestion['id'],
                          productDetailName: suggestion['name'],
                          productDetailCategory: suggestion['category'],
                          productDetailPrice: productPrice.toString(),
                          productDetailQuantity: suggestion['quantity'],
                          productDetailOldPrice: suggestion['costPrice'],
                          productDetailPicture: suggestion['image'],
                        )));
          },
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text('Kumar');
      }
    });
  }

  void getBannerImages() async {
    images = await _bannerServices.getImages();
    setState(() {
      images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    //=============Carousel================
    Widget imageCarousel = Container(
      height: 300.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        images: images,
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
          title: _appBarTitle,
          actions: <Widget>[
            IconButton(icon: _searchIcon, onPressed: searchProducts),
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

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 150.0,
                ),
                HorizontalListCategories(),
                Divider(
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                  child: Text(
                    'Favourite Products',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                FavoriteProducts()
              ]),
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
