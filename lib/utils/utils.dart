import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momworkapp/Screen/auth/LoginHomeScreen.dart';
import 'package:momworkapp/Screen/auth/LoginScreen.dart';
import 'package:momworkapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

textFieldBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.black12));
}

String timeAgo({required DateTime creteTime, bool numericDates = true}) {
  final date2 = DateTime.now();
  final difference = date2.difference(creteTime);

  if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return '${difference.inSeconds} seconds ago';
  } else {
    return 'Just now';
  }
}

class Utils {
  static SharedPreferences? prefs;
  static logApiData({
    required String url,
    String? body,
    required String response,
    required int code,
    String? header,
  }) {
    log("API Url : $url");
    log("API Body : $body");
    log("API Status Code : $code");
    log("API Response : $response");
    log("API Header : $header");
  }

  static logout() {
    Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) {
      return LoginHomeScreen();
    },), (route) => false);
    Fluttertoast.showToast(
      msg: "Session Expired! Please Login Again..",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static String? passwordValidator(String value, {String? oldPassword}) {
    if(value.isEmpty) {
      return "Please Enter Password";
    } else if(!RegExp(r'^(?=.*?[A-Za-z])').hasMatch(value)) {
      return "Please Enter 1 Alphabet Character";
    } else if(!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
      return "Password should contain at least one digit";
    } else if(value.length < 8) {
      return "Password must be at least 8 characters in length ";
    } else if (oldPassword != null && oldPassword == value) {
      return "Password should be different from your old password";
    }
    return null;
  }
}
