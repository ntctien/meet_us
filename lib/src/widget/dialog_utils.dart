import 'package:flutter/material.dart';

class DialogUtils {
  static OverlayEntry? _overlayEntry;

  static void showLoading(BuildContext context) {
    dismissLoading();
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Container(
          color: Colors.black26,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismissLoading() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }
}
