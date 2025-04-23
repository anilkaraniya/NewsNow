import 'package:flutter/material.dart';

class CustomSnackBar {
  static showSuccessSnackBar(
    BuildContext context, {
    required String message,
    int milliseconds = 2000,
    SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating,
    Color color = Colors.green,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: snackBarBehavior,
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static void showSystemErrorSnackBar(BuildContext context,
      {String? message,
      int milliseconds = 2000,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF647C),
        behavior: snackBarBehavior,
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message ?? 'An error occured',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static void showBusinessLogiErrorSnackBar(BuildContext context,
      {String? message,
      int milliseconds = 2000,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 234, 0, 255),
        behavior: snackBarBehavior,
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message ?? 'An error occured',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context,
      {String? message,
      int milliseconds = 2000,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.floating}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF647C),
        behavior: snackBarBehavior,
        duration: Duration(milliseconds: milliseconds),
        content: SelectableText(
          message ?? 'An error occured',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
