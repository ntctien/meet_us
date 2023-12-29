import 'package:flutter/material.dart';
import 'package:meet_us/src/entity/user.dart';

class AppUtils {
  static void dismissFocusNode(BuildContext context) {
    final FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    return;
  }

  static bool isEmail(String? email) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return (email == null) ? false : RegExp(pattern).hasMatch(email);
  }

  static String getDisplayUserName(User? user, {bool onlyFirstChar = false}) {
    String name = 'N/A';
    if (user != null) {
      if (user.name.isNotEmpty) {
        return onlyFirstChar ? user.name[0].toUpperCase() : user.name;
      }
      name = onlyFirstChar ? user.email[0].toUpperCase() : user.email;
    }
    return name;
  }
}
