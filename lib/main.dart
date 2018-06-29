import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/widgets/pages/create_open_order_page/create_open_order_page.dart';
import 'package:sambl/widgets/pages/home_page/home_page.dart';
import 'package:sambl/widgets/pages/open_order_list_page/open_order_list_page.dart';
import 'package:sambl/widgets/pages/place_order_page.dart';
import 'package:sambl/widgets/pages/sign_in_page.dart';
import 'package:sambl/widgets/pages/sign_up_page.dart';
import 'package:sambl/widgets/pages/start_page.dart';

import 'package:sambl/state/app_state.dart';
import 'package:sambl/reducer/primary_reducer.dart';
import 'package:sambl/middleware/firebase_auth_middleware.dart';

void main() {
  final Store<AppState> store = new Store<AppState>(
    primaryReducer, /* Function defined in the reducers file */
    initialState: new AppState.unauthenticated(),
    middleware: [thunkMiddleware],
  );

  runApp(new MyApp(
    store: store,
  ));
}

Widget defaultPage(AppStatusFlags flag) {
  switch (flag) {
    case AppStatusFlags.unauthenticated:
      return new SignInPage();
    case AppStatusFlags.authenticated:
      return new SignInPage();
  }
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.green,
        ),
        home: new StartPage(),
        routes: <String, WidgetBuilder> {
          "/CreateOpenOrderPage" : (BuildContext context) => new CreateOpenOrderPage(),
          "/HomePage" : (BuildContext context) => new HomePage(),
          "/OpenOrderListPage" : (BuildContext context) => new OpenOrderListPage(),
          "/PlaceOrderPage" : (BuildContext context) => new PlaceOrderPage(),
          "/SignInPage" : (BuildContext context) => new SignInPage(),
          "/SignUpPage" : (BuildContext context) => new SignUpPage(),
        },
      )
    );
  }
}
