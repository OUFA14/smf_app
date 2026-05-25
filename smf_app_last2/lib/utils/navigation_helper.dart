import 'package:flutter/material.dart';

class AppNavigation {
  static Future<bool> handleSystemBack(BuildContext context,
      {String fallbackRoute = '/'}) async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return false;
    } else {
      Navigator.pushReplacementNamed(context, fallbackRoute);
      return false;
    }
  }

  static void goBack(BuildContext context, {String fallbackRoute = '/'}) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, fallbackRoute);
    }
  }
}
