import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, {Color colorBg = Colors.black54, Color colorLbl = Colors.white} ) {
    final sncakBar = SnackBar(
      content: Text(message, style: TextStyle(color: colorLbl, fontSize:18.0),),
      duration: Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: colorBg,
    );

    messengerKey.currentState!.showSnackBar(sncakBar);
  }
}
