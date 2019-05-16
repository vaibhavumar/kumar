import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:kumar/components/searchProduct.dart';
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
  SharedPreferences sharedPreferences;
  UserServices userServices = UserServices();
  BannerServices _bannerServices = BannerServices();
  List<NetworkImage> images = List<NetworkImage>();

  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    getBannerImages();
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 0.7)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  void getBannerImages() async {
    images = await _bannerServices.getImages();
    setState(() {
      images = images;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double viewWidth = MediaQuery.of(context).size.width,
        viewHeight = MediaQuery.of(context).size.height;

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

    return Scaffold(
      body: Stack(children: [
        Container(
          height: viewHeight,
          color: Colors.black.withOpacity(0.8),
        ),
        DrawerComponent(),
        AnimatedBuilder(
          animation: controller,
          builder: (context, widget) {
            return Transform(
              transform: Matrix4.translationValues(
                  0.0, animation.value * viewHeight, 0.0),
              child: ListView(
                children: <Widget>[
                  CustomPaint(
                    painter: MyBottle(),
                    size: Size(viewWidth, viewHeight * 0.4),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: imageCarousel),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: HorizontalListCategories(),
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 5.0),
                          child: Text(
                            'Favourite Products',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        FavoriteProducts()
                      ],
                    ),
                    color: Colors.deepOrange,
                  ),
                  Container(
                    color: Colors.transparent,
                    child: CustomPaint(
                      size: Size(viewWidth, viewHeight * 0.2),
                      painter: MyBottleBottom(),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        Positioned(
          top: 20.0,
          right: 20.0,
          child: IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: controller,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              if (controller.status == AnimationStatus.completed)
                controller.reverse();
              else
                controller.forward();
            },
          ),
        )
      ]),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//    var w = MediaQuery.of(context).size.width;
//    var h = MediaQuery.of(context).size.height;
//    //=============Carousel================
//    Widget imageCarousel = Container(
//      height: 300.0,
//      child: Carousel(
//        boxFit: BoxFit.cover,
//        images: images,
//        autoplay: true,
//        animationCurve: Curves.fastOutSlowIn,
//        animationDuration: Duration(milliseconds: 1000),
//      ),
//    );
//
//    return Container(
//      decoration: BoxDecoration(
//        color: Theme.of(context).backgroundColor,
//      ),
//      child: Scaffold(
//        backgroundColor: Colors.transparent,
//        appBar: AppBar(
//          title: Text("Kumar"),
//          actions: <Widget>[
//            IconButton(
//                icon: Icon(Icons.search),
//                onPressed: () {
//                  showSearch(
//                      context: context, delegate: CustomSearchDelegate(null));
//                }),
//            IconButton(
//                icon: Icon(
//                  Icons.shopping_cart,
//                  color: Colors.white,
//                ),
//                onPressed: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) =>
//                              InheritedCart(child: ShoppingCart())));
//                })
//          ],
//          elevation: 10.0,
//        ),
//        drawer: DrawerComponent(),
//        body: SingleChildScrollView(
//          scrollDirection: Axis.vertical,
//          child: Stack(
//            children: <Widget>[
//              //=======Carousel===========
//              ClipPath(
//                clipper: GetClipper(),
//                child: imageCarousel,
//              ),
//              // //=======Horizontal List Categories====
//
//              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                SizedBox(
//                  height: 150.0,
//                ),
//                AnimatedBuilder(
//                  animation: _controller,
//                  builder: (context, child) {
//                    return Transform(
//                        transform: Matrix4.translationValues(
//                            animationHorizontal.value * w, 0.0, 0.0),
//                        child: HorizontalListCategories());
//                  },
//                ),
//                Divider(
//                  color: Colors.white,
//                ),
//                Padding(
//                  padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
//                  child: Text(
//                    'Favourite Products',
//                    style: TextStyle(color: Colors.white, fontSize: 20.0),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: AnimatedBuilder(
//                    animation: _controller,
//                    builder: (context, child) {
//                      return Transform(
//                        transform: Matrix4.translationValues(
//                            0.0, animationVertical.value * h, 0.0),
//                        child: FavoriteProducts(),
//                      );
//                    },
//                  ),
//                )
//              ]),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
}

class MyBottleBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.deepOrange;
    double top = 0.0, width = size.width / 3, height = size.height;
    Rect oval1 = Rect.fromLTWH(0.0, top, width, height),
        oval2 = Rect.fromLTWH(width, top, width, height),
        oval3 = Rect.fromLTWH(size.width - width, top, width, height);
    canvas.drawOval(oval1, paint);
    canvas.drawOval(oval2, paint);
    canvas.drawOval(oval3, paint);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, height / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MyBottle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;
    Rect oval = Rect.fromLTRB(0.0, size.height * 0.4, size.width, size.height);
    canvas.drawOval(oval, paint);
    Path bottleNeck = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.45, size.height * 0.35,
          size.width * 0.4, size.height * 0.2)
      ..lineTo(size.width * 0.6, size.height * 0.2)
      ..quadraticBezierTo(size.width * (1 - 0.45), size.height * 0.35,
          size.width * 0.8, size.height * 0.5);
    canvas.drawPath(bottleNeck, paint);
    RRect cap = RRect.fromRectAndRadius(
        Rect.fromLTRB(
            size.width * 0.39, 0.0, size.width * 0.61, size.height * 0.21),
        Radius.circular(10.0));
    canvas.drawRRect(cap, paint);
    canvas.drawRect(
        Rect.fromLTRB(0.0, size.height * 0.72, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
