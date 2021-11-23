import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final sncakBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,
    );

    messengerKey.currentState!.showSnackBar(sncakBar);
  }
}
