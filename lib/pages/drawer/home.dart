import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//=====My Packages=======
import 'package:kumar/components/drawer.dart';
import 'package:kumar/components/horizontal_list.dart';
import 'package:kumar/pages/drawer/cart.dart';
import '../../db/users.dart';
import 'package:kumar/components/recents_grid.dart';
import '../../db/bannerImages.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation animationHorizontal;
  Animation animationVertical;

  SharedPreferences sharedPreferences;
  UserServices userServices = UserServices();
  BannerServices _bannerServices = BannerServices();
  List<NetworkImage> images = List<NetworkImage>();

  @override
  void initState() {
    super.initState();
    getBannerImages();
    _controller = AnimationController(
        duration: Duration(milliseconds: 2500), vsync: this);
    animationHorizontal = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    animationVertical = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceIn));
  }

  void getBannerImages() async {
    images = await _bannerServices.getImages();
    setState(() {
      images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
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
          title: Text("Kumar"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InheritedCart(child: ShoppingCart())));
                })
          ],
          elevation: 10.0,
        ),
        drawer: DrawerComponent(),
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
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform(
                        transform: Matrix4.translationValues(
                            animationHorizontal.value * w, 0.0, 0.0),
                        child: HorizontalListCategories());
                  },
                ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            0.0, animationVertical.value * h, 0.0),
                        child: FavoriteProducts(),
                      );
                    },
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
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
