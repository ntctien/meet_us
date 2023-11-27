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

  static String getDisplayUserName(User? user) {
    String name = 'N/A';
    if (user != null && user.email.isNotEmpty) {
      name = user.email[0].toUpperCase();
    }
    return name;
  }
}
