import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sambl/action/authentication_action.dart';
import 'package:sambl/state/app_state.dart';
import 'package:sambl/utility/firebase_reader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class FirebaseUserAction {
  final FirebaseUser user;

  void run(Store<AppState> store);
}

class VerifyUserAction implements FirebaseUserAction {
  final FirebaseUser user;

  VerifyUserAction(FirebaseUser user): this.user = user;

  @override
  void run(Store<AppState> store) async {
    print('verifying user');
    Firestore.instance.collection('users').document(user.uid).get()
      .then((document) => document.data, onError: (error) => store.dispatch(new RequestSignUpAction(this.user)))
      .then((data) async {
        if (data['isOrdering']) {
          print("is ordering");
          new FirebaseMessaging().subscribeToTopic(data['currentOrder'].documentId);
          store.dispatch(new LoginWhileOrderingAction(new User(this.user), 
            await orderReader(data['currentOrder'])));
        } else if (data['isDelivering']) {
          print("is delivering");
            store.dispatch(new LoginWhileDeliveringAction(new User(this.user), 
              new CombinedDeliveryList(
                pending: await deliveryListReader(data['currentDelivery'],DeliveryListType.pending),
                approved: await deliveryListReader(data['currentDelivery'],DeliveryListType.approved),
                detail: await data['currentDelivery'].get().then((delivery) => orderDetailReader(delivery.data['detail'])))));
        } else {
          print("nether ordering nor delivering");
          store.dispatch(new LoginAction(new User(this.user)));
        }
      });
  }
}