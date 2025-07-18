import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, {String? message}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                message ?? "Please wait...",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
