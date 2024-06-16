import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySnackbar {
  static void show({
    String title = "Error",
    Duration duration = const Duration(seconds: 3),
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromRGBO(129, 199, 132, 1),
      colorText: Colors.red[800],
      icon: Icon(Icons.info, color: Colors.red[800]),
      shouldIconPulse: true,
      duration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 400),
      borderRadius: 100.0,
      margin: EdgeInsets.all(10.0),
      snackStyle: SnackStyle.FLOATING,
      // isDismissible: false,
      // dismissDirection: SnackDismissDirection.HORIZONTAL,
    );
  }
}
