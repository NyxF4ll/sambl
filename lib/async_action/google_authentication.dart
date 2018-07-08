import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiver/core.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/async_action/verify_user.dart';

import 'package:sambl/subscribers/get_user_subscription.dart';
import 'package:sambl/subscribers/subscriber.dart';



  final ThunkAction<AppState> signInWithGoogleAction = (Store<AppState> store) async {
    await _handleGoogleSignIn()
      .then((user) {
        CombinedSubscriber.instance().add(name: "userSubscription", 
          subscription: toUserSubscription(user,store));
      })
      .catchError((error) => print(error));
  };


  Future<FirebaseUser> _handleGoogleSignIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = new GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }