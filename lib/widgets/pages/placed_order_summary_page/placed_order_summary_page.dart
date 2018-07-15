import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:sambl/model/order.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/state/app_state.dart';// Action
import 'package:sambl/main.dart'; // To access our store (which contains our current appState).
import 'package:sambl/widgets/shared/my_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_widget.dart';
import 'package:sambl/widgets/pages/place_order_page/place_order_page.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/quantity_display.dart';
import 'package:sambl/widgets/pages/view_order_page/view_order_page.dart';
import 'dart:isolate';

class PlacedOrderSummaryPage extends StatefulWidget {
  OrderModel orderModel; // when first navigated to this page, we use the orderModel
  // passed from place_order_page. When the real order from the database changes,
  // we replace the orderModel with the real order.

  PlacedOrderSummaryPage(this.orderModel) {
    print("inside PlaceOrderSummaryPage constructor ${orderModel.order.stalls}");
  }

  @override
  _PlacedOrderSummaryPageState createState() => _PlacedOrderSummaryPageState();
}

class _PlacedOrderSummaryPageState extends State<PlacedOrderSummaryPage> {
  GlobalKey<RefreshIndicatorState> refreshKey = new GlobalKey<RefreshIndicatorState>();

  Future<Null> _updateETALabel() async {
    refreshKey.currentState.show();
    print("inside updateetalabel");
    int diff = widget.orderModel.order.orderDetail.eta.difference(DateTime.now()).inMinutes;

    print("updated ETA label");
    setState(() {
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().build(context),
      backgroundColor: MyColors.mainBackground,
      body: new Column(
        children: <Widget>[
          // This is the title 'Delivering from: ...'
          new Container(
            margin: new EdgeInsets.only(top: 10.0, bottom: 5.0),
            color: Colors.white,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child:  new Text("Delivering from",
                    style: new TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // This is the summary order placed by the current user.
          new Expanded(
            child: new Container(
              color: Colors.white,
              margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: new RefreshIndicator(
                key: refreshKey,
                onRefresh: _updateETALabel,
                child: new ListView(
                  children: <Widget>[
                    // 'status' and 'view order button'
                    new Row(
                      children: <Widget>[
                        // 'e.g. Status: awaiting payment '
                        new Expanded(
                          flex: 5,
                          child: new Container(
                            padding: new EdgeInsets.only(left: 20.0),
                            child: new Row(
                              children: <Widget>[
                                new Text("Status:",
                                  style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700 ),
                                ),
                                new Text("    Awaiting payment",
                                  style: new TextStyle(fontSize: 20.0),
                                )
                              ],
                            ),
                          ),
                        ),

                        // 'view order' button
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            margin: new EdgeInsets.only(top: 15.0, bottom: 15.0, right: 20.0),
                            padding: new EdgeInsets.all(5.0),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0),
                              border: new Border.all(color: MyColors.mainBackground, width: 2.0)
                            ),
                            child: new FlatButton(
                              onPressed: () {
                                print("View order button tapped! order of orderModel in view_order_page is ${widget.orderModel}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) {
                                          print("""
                                          inside MaterialPageRoute builder for ViewOrderPage, 
                                          orderModel to be passed to ViewOrderPage is ${widget.orderModel}""");
                                          return new ViewOrderPage(widget.orderModel);
                                        }
                                    )
                                );

                              },
                              child: new Center(child: new Text("View order")),
                            ),
                          ),
                        )
                      ],
                    ),

                    // some space betwn 'status' row and 'eta' row
                    // just a space
                    new Container(
                      height: 10.0,
                      color: new Color(0xFFEBEBEB),
                    ),

                    //ETA and PickUpLocation
                    new Container(
                      padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: new Row(
                        children: <Widget>[
                          //ETA
                          new Expanded(
                            flex: 1,
                            child: new Row(
                              children: <Widget>[
                                new QuantityDisplay(
                                  head: new QuantityDisplayElement(content: "ETA"),
                                  quantity: new QuantityDisplayElement(fontSize: 35.0,content: "${widget.orderModel.order.orderDetail.eta.difference(DateTime.now()).inMinutes}"),//"${widget.orderModel.order.orderDetail.eta}"),
                                  tail: new QuantityDisplayElement(content: "mins"),
                                )
                              ]
                            ),
                          ),

                          // pickup location
                          new Expanded(
                            flex: 2,
                            child: new Column(
                              children: <Widget>[
                                new Text("Pick-up location",
                                  style: new TextStyle(fontSize: 25.0),
                                ),
                                new Text("Cinnamon College",
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),

          // Open Chat
          new Center(
            child: new Container(
              margin: new EdgeInsets.only(top: 130.0),
              color: Colors.white,
              // TRIGGER OpenChat Action
              child: new StoreConnector<AppState, Store<AppState>>(
                converter: (store) => store,
                builder: (_, store){
                  return new FlatButton(
                    padding: new EdgeInsets.all(10.0),
                    onPressed: (){
                      //TRIGGER SubmitOrderAction.
                      Optional<Order> newOrder = store.state.currentOrder;
                      // The reducer shd create a new state w new Order. Then inform Firebase (async).
                      //store.dispatch(new OrderAction(order: newOrder));
                      print("Opening Chat.");

                      // Navigate to a page to chat page
                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                              return new ScopedModelDescendant<OrderModel>(
                                                builder: (context, child, orderModel) {
                                                  return new PlacedOrderSummaryPage(orderModel);
                                                },

                                              );
                                            }
                                        )
                                    );*/


                    },
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Text("Open Chat",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.green,
                            fontSize: 17.0
                        ),
                      ),
                    ),
                  );
                },

              ),


            ),
          ),

          // some space betwn 'Open Chat' row and 'Authorise Payment' row
          // just a space
          new Container(
            height: 10.0,
            color: new Color(0xFFEBEBEB),
          ),

          // Authorise Payment
          new Center(
            child: new Container(
              color: Colors.white,
              // TRIGGER OpenChat Action
              child: new StoreConnector<AppState, Store<AppState>>(
                converter: (store) => store,
                builder: (_, store){
                  return new FlatButton(
                    padding: new EdgeInsets.all(10.0),
                    onPressed: (){
                      //TRIGGER SubmitOrderAction.
                      Optional<Order> newOrder = store.state.currentOrder;
                      // The reducer shd create a new state w new Order. Then inform Firebase (async).
                      //store.dispatch(new OrderAction(order: newOrder));
                      print("Authorise Payment.");

                      // Navigate to a page to chat page
                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) {
                                              return new ScopedModelDescendant<OrderModel>(
                                                builder: (context, child, orderModel) {
                                                  return new PlacedOrderSummaryPage(orderModel);
                                                },

                                              );
                                            }
                                        )
                                    );*/


                    },
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      child: new Text("Authorise Payment",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: MyColors.mainRed,
                            fontSize: 17.0
                        ),
                      ),
                    ),
                  );
                },

              ),


            ),
          ),

        ]
      ),
    );
  }


}
