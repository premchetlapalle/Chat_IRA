import 'package:flutter/material.dart';

class Dialogs {

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Text(msg),
      backgroundColor: Colors.black.withOpacity(0.6),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
