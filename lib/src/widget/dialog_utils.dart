import 'package:flutter/material.dart';

class DialogUtils {
  static void showLoading(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 100),
            curve: Curves.decelerate,
            padding: MediaQuery.viewInsetsOf(context) +
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: MediaQuery.removeViewInsets(
              removeLeft: true,
              removeTop: true,
              removeRight: true,
              removeBottom: true,
              context: context,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 40.0,
                    maxWidth: 40.0,
                    minHeight: 40.0,
                    maxHeight: 40.0,
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
