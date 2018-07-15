import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/subscribers/combined_subscriber.dart';

  final ThunkAction<AppState> signOutAction = (Store<AppState> store) async {
    await CombinedSubscriber.instance().removeAll();
    
    FirebaseAuth.instance.currentUser().then((user){
      GoogleSignIn _googleSignIn = new GoogleSignIn(
        scopes: ['email','https://www.googleapis.com/auth/contacts.readonly']);
      _googleSignIn.signOut();
    });

    await FirebaseAuth.instance.signOut()
      .then((_) {
        print('signing out');
        store.dispatch(new LogoutAction());
      });
  };
