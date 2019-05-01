import 'package:flutter/material.dart';
import 'package:kumar/pages/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/favoriteDetails.dart';

class FavoriteProducts extends StatefulWidget {
  @override
  _FavoriteProductsState createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends State<FavoriteProducts> {
  Firestore _firestore = Firestore.instance;
  FavoriteDetails _favoriteDetails = FavoriteDetails();
  List<dynamic> favorites;

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  void getFavorites() async {
    favorites = await _favoriteDetails.getFavorites();
    for (String favorite in favorites) {
      QuerySnapshot snaps = await _firestore
          .collection('products')
          .where('id', isEqualTo: favorite)
          .getDocuments();
      Map<String, dynamic> productDetail = snaps.documents.first.data;
      setState(() {
        productList.add(productDetail);
      });
    }
  }

  var productList = [];

  @override
  Widget build(BuildContext context) {
    return productList.length == 0
        ? Center(
            child: Text('No Favorites'),
          )
        : GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: productList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              double costPrice = double.parse(productList[index]['costPrice']);
              double discount = double.parse(productList[index]['discount']);
              var sellingPrice = costPrice - (costPrice * (discount / 100));
              return SingleProduct(
                productId: productList[index]['id'],
                productName: productList[index]["name"],
                productPicture: productList[index]["image"],
                productOldPrice: costPrice,
                productPrice: sellingPrice,
                productDiscount: discount,
                productQuantity: productList[index]['quantity'],
                productCategory: productList[index]['category'],
              );
            },
          );
  }
}

class SingleProduct extends StatelessWidget {
  final productId;
  final productName;
  final productPicture;
  final productOldPrice;
  final productPrice;
  final productDiscount;
  final productQuantity;
  final productCategory;

  SingleProduct({
    @required this.productId,
    @required this.productDiscount,
    @required this.productName,
    @required this.productPicture,
    @required this.productOldPrice,
    @required this.productPrice,
    @required this.productQuantity,
    @required this.productCategory,
  });

  @override
  Widget build(BuildContext context) {
    //=======Grid Products========
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.red, width: 2.0)),
      child: InkWell(
        //=======Page Routing======
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            //=======Passing values to ProductDetails=======
            builder: (context) => ProductDetails(
                  productDetailId: productId,
                  productDetailQuantity: productQuantity,
                  productDetailName: productName,
                  productDetailPicture: productPicture,
                  productDetailOldPrice: productOldPrice,
                  productDetailPrice: productPrice,
                  productDetailCategory: productCategory,
                ))),
        //====End of Routing=====
        child: GridTile(
          header: Container(
            decoration: BoxDecoration(
                color: Colors.deepOrange.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$productDiscount\% off',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          footer: Container(
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0))),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      productName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "₹$productOldPrice",
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                      Text(
                        "₹$productPrice",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //=======Product Image=========
          child: Image.network(
            productPicture,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
