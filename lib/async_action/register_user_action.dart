import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/async_action/sign_out.dart';
import 'package:sambl/state/app_state.dart';

final ThunkAction<AppState> registerUserAction = (Store<AppState> store) async {
  CloudFunctions.instance.call(functionName: "registerUser");
  await FirebaseAuth.instance.currentUser().then((user) => store.dispatch(LoginAction(new User(user))));
  print("firebase user is ${await FirebaseAuth.instance.currentUser()}, appstate's user is ${store.state.currentUser}");
};

final ThunkAction<AppState> cancelSignupAction = (Store<AppState> store) async {
  // call some function
  store.dispatch(signOutAction);
};