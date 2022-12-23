import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, {required String title, Color? backgroundColor, Color? titleColor, Duration duration = const Duration(seconds: 1)}){
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.showSnackBar(
    SnackBar(
      duration: duration,
      backgroundColor: backgroundColor,
      content: Text(title,
        style: TextStyle(
          color: titleColor,
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),
    )
  );
}