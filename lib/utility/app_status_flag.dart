import 'package:flutter/material.dart';

import 'package:sambl/widgets/pages/home_page/home_page.dart';
import 'package:sambl/widgets/pages/sign_in_page.dart';

Widget defaultPage(AppStatusFlags flag) {
  return new SignInPage();
  switch (flag) {
    case AppStatusFlags.unauthenticated:
      return new SignInPage();
    case AppStatusFlags.authenticated:
      return new HomePage();
    case AppStatusFlags.awaitingSignup:
      return new SignInPage();
    case AppStatusFlags.delivering:
      return new SignInPage();
    case AppStatusFlags.ordering:
      return new SignInPage();
  }
}


/// Status flags of the application
enum AppStatusFlags {
  /// State of the application when no user has been signed in
  unauthenticated,
  /// State of the application while waiting for the user to complete signup
  awaitingSignup,
  /// State of the application when a user is signed in but has neither started nor joined an order
  authenticated,
  /// State of the application when a user is currently ordering food
  ordering,
  /// State of the application when a user is currently delivering food
  delivering
}