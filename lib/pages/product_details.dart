import 'package:flutter/material.dart';
import '../db/cartDetails.dart';
import '../db/favoriteDetails.dart';

class ProductDetails extends StatefulWidget {
  final productDetailName;
  final productDetailPicture;
  final productDetailOldPrice;
  final productDetailPrice;
  final productDetailQuantity;
  final productDetailCategory;
  final productDetailId;

  ProductDetails({
    this.productDetailId,
    this.productDetailCategory = 'null',
    this.productDetailName,
    this.productDetailPicture,
    this.productDetailOldPrice,
    this.productDetailPrice,
    this.productDetailQuantity = 'null',
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  CartDetails _cartDetails = CartDetails();
  FavoriteDetails _favoriteDetails = FavoriteDetails();
  Color _favoriteIconColor = Colors.black;
  Color _cartIconColor = Colors.black;

  @override
  void initState() {
    super.initState();
    checkCart();
  }

  checkCart() async {
    if (await _cartDetails.alreadyInCart(widget.productDetailId)) {
      setState(() {
        _cartIconColor = Colors.red;
      });
    }
    if (await _favoriteDetails.alreadyInFavorites(widget.productDetailId)) {
      setState(() {
        _favoriteIconColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(widget.productDetailCategory),
        elevation: 0.3,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(widget.productDetailPicture),
              ),
              footer: Container(
                color: Colors.white70,
                child: ListTile(
                  leading: Text(
                    '${widget.productDetailName}(${widget.productDetailQuantity})',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        child: Text(
                          '₹${widget.productDetailOldPrice}',
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '₹${widget.productDetailPrice}',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //=========Button==========
          Row(
            children: <Widget>[
              //========Quantity Button=========
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Quantity"),
                              content: Text("All Quantities"),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(context);
                                  },
                                  child: Text("close"),
                                )
                              ],
                            ));
                  },
                  color: Colors.white,
                  textColor: Colors.grey,
                  elevation: 0.2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Opacity(
                            opacity: 0.0, child: Icon(Icons.remove_circle)),
                      ),
                      Expanded(
                        child: Text(
                          "Quantity",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_drop_down_circle),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //=========Button==========
          Row(
            children: <Widget>[
              //========Buy Now Button=========
              Expanded(
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.deepOrangeAccent,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: Text("Buy Now"),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                color: _cartIconColor,
                onPressed: () {
                  if (this._cartIconColor == Colors.red) {
                    _cartDetails.removeProductFromCart(widget.productDetailId);
                    setState(() {
                      _cartIconColor = Colors.black;
                    });
                  } else {
                    _cartDetails.addProductToCart(widget.productDetailId);
                    setState(() {
                      _cartIconColor = Colors.red;
                    });
                  }
                },
              ),
              IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: _favoriteIconColor,
                  onPressed: () {
                    if (this._favoriteIconColor == Colors.red) {
                      _favoriteDetails
                          .removeProductFromFavorites(widget.productDetailId);
                      setState(() {
                        _favoriteIconColor = Colors.black;
                      });
                    } else {
                      _favoriteDetails
                          .addProductToFavorites(widget.productDetailId);
                      setState(() {
                        _favoriteIconColor = Colors.red;
                      });
                    }
                  })
            ],
          ),
          Divider(
            color: Colors.deepOrange,
          ),
          ListTile(
            title: Text("Product Details"),
            subtitle: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
          ),
        ],
      ),
    );
  }
}
