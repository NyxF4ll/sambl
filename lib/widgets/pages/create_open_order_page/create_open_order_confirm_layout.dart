import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sambl/model/order_detail.dart';
import 'package:sambl/main.dart';
import 'package:sambl/widgets/shared/my_color.dart';
import 'package:sambl/widgets/shared/quantity_display.dart';
import 'package:sambl/utility/geo_point_utilities.dart';
import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
import 'package:sambl/state/app_state.dart';
import 'package:redux/redux.dart';

/// This class constructs the layout for confirmation page for creating open order. This layout
/// would be the last tabbarview child in the 'create open order page'.
/// This layout gives a summary of the open order created by the user and wrap all the information
/// provided in the previous two tabs (tabbarview children) in [OrderDetail].
/// This layout uses redux to dispatch DeliverAction with OpenOrder obj.
class CreateOpenOrderConfirmLayout extends StatefulWidget {



  CreateOpenOrderConfirmLayout() {

  }

  @override
  _CreateOpenOrderConfirmLayoutState createState() => _CreateOpenOrderConfirmLayoutState();
}

class _CreateOpenOrderConfirmLayoutState extends State<CreateOpenOrderConfirmLayout> {


  //
  Future<Null> _refreshPickupPoint() async {
    setState((){});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState,Store<AppState>>(
        converter: (store) => store,
        builder: (context,store) => new Column(
          children: <Widget>[
            // Title: Delivery Summary
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 20.0),
              decoration: new BoxDecoration(
                  border: new Border.all(color: MyColors.borderGrey, width: 1.8),
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
              child: new Center(
                child: new Text("Summary",
                  style: new TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),

            new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0)),
            // The summary body

            new ScopedModelDescendant<Info>(
              builder: (context, child, info) {
                return new Container(
                  height: 270.0,
                  margin: new EdgeInsets.symmetric(horizontal: 20.0),
                  padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(color: MyColors.borderGrey, width: 1.8),
                      borderRadius: new BorderRadius.all(new Radius.circular(15.0))),
                  child: RefreshIndicator(
                    onRefresh: _refreshPickupPoint,
                    child: new ListView(
                      children: <Widget>[
                        // This row shows the pickup point.
                        // Borderless container.
                        ScopedModelDescendant<Info>(
                          builder: (_, child, info) {

                            return FutureBuilder<String>(
                              initialData: "...",
                              future: reverseGeocodeFuture(store.state.currentLocation),
                              builder: (_, AsyncSnapshot<String> snapshot) {

                                return new Container(
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Text("${snapshot.hasData ? 'Delivering to ${snapshot.data}' : 'loading pickup point...'}",
                                          style: new TextStyle(
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),


                        // some space between 'pickup pt' row and 'other details' row
                        new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 10.0),
                        ),

                        // This row shows the 'order closing time', 'eta' and 'num of dishes to deliver'.
                        // Borderless container
                        new Container(
                          child: new Row(
                            children: <Widget>[
                              // This wid rep closing time
                              new QuantityDisplay(
                                head: new QuantityDisplayElement(
                                  content: "closing in",
                                ),
                                quantity: new QuantityDisplayElement(
                                    content: "${info.closingTime?.difference(DateTime.now())?.inMinutes ?? 'X'}"
                                ),
                                tail: new QuantityDisplayElement(
                                    content: "min"
                                ),
                              ),



                              // This wid rep eta
                              new QuantityDisplay(
                                head: new QuantityDisplayElement(
                                  content: "ETA",
                                ),
                                quantity: new QuantityDisplayElement(
                                    content: "${info.eta?.difference(DateTime.now())?.inMinutes ?? 'X'}"
                                ),
                                tail: new QuantityDisplayElement(
                                    content: "min"
                                ),
                              ),


                              // This wid rep number of dishes to deliver.
                              new QuantityDisplay(
                                head: new QuantityDisplayElement(
                                  content: "Delivering",
                                ),
                                quantity: new QuantityDisplayElement(
                                    content: "${info.maxNumberofDishes}"
                                ),
                                tail: new QuantityDisplayElement(
                                    content: "dishes"
                                ),
                              ),

                            ],
                          ),
                        ),

                        // Some space btwn 'additional detail' and the prev 'quantity display' row.
                        new Padding(
                            padding: new EdgeInsets.symmetric(vertical: 10.0)
                        ),
                        // This last part shows the additional remark
                        new Container(
                          child: new Column(
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new Text("Additional Remarks: ",
                                    style: new TextStyle(
                                        fontSize: 18.0
                                    ),
                                  )
                                ],
                              ),
                              new Padding(padding: new EdgeInsets.symmetric(vertical: 10.0),),
                              new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new Text("${info.remarks}",
                                      style: new TextStyle(
                                          fontSize: 16.0
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),



                      ],
                    ),
                  ),
                );
              },
            ),


          ],
        )
    );
  }
}