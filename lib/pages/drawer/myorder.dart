import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kumar/db/orderDetails.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Orders'),
        elevation: 0.3,
      ),
      body: BuildOrders(),
    );
  }
}

class BuildOrders extends StatefulWidget {
  @override
  _BuildOrdersState createState() => _BuildOrdersState();
}

class _BuildOrdersState extends State<BuildOrders> {
  OrderDetails orderDetails = OrderDetails();
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<DocumentSnapshot>>(
        future: orderDetails.getOrders(),
        builder: (context, orderFuture) {
          if (orderFuture.hasData) {
            if (orderFuture.data != null) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: orderFuture.data,
                  builder: (context, orderSnaps) {
                    return ListView.builder(
                        itemCount: orderSnaps.data['orders'].length,
                        itemBuilder: (context, index) {
                          return _buildOrder(
                              orderSnaps.data['orders'][index].path);
                        });
                  });
            }
          } else
            return Center(child: CircularProgressIndicator());
        });
  }

  _buildOrder(String path) {
    return StreamBuilder(
      stream: _firestore.document(path).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> orderDocument) {
        if (!orderDocument.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
            title: Text('Order Id: ${orderDocument.data['orderId']}'),
            subtitle: _buildProducts(context, orderDocument.data['orders']),
            trailing: Container(
              padding: EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.deepOrange,
              ),
              child: Text(
                orderDocument.data['status'],
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildProducts(BuildContext context, List<dynamic> products) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return StreamBuilder(
            stream: _firestore
                .collection('products')
                .document(products[index])
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> product) {
              if (!product.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Container(
                constraints: BoxConstraints(
                  minHeight: 100.0,
                ),
                color: Colors.grey,
                child: ListTile(
                    title: Text(product.data['name']),
                    trailing: CircleAvatar(
                      maxRadius: 40.0,
                      backgroundImage: NetworkImage(product.data['image']),
                    )),
              );
            },
          );
        });
  }
}
