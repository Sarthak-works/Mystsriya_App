import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:momworkapp/Screen/auth/LoginHomeScreen.dart';
import 'package:momworkapp/Screen/auth/LoginScreen.dart';
import 'package:momworkapp/models/common_auth_model.dart';
import 'package:momworkapp/utils/utils.dart';

class Services {
  // 1. LOGIN API call

  Future<CommonLoginModel?> login(context, {required body}) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/login');

    var result = await http.post(url, body: body);

    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        var model = CommonLoginModel.fromJson(response);
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return model;
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      Navigator.pop(context);
      return null;
    }
  }

  // 1.1 Google Login API Call

   gLogin(context, {required body, deleteAccount=false}) async {
    var url =
    Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/glogin');

    var result = await http.post(url, body: body);

    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      var model;
      if (response['data']!=null)
        model = CommonLoginModel.fromJson(response);
      else
        model = googleLoginModel.fromJson(response);

      if (response['success'] == true) {
      //  var model = CommonLoginModel.fromJson(response);
        if (deleteAccount) {
          Fluttertoast.showToast(
            msg: "We have received your request and will notify you via email once it has been processed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: response['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }

        return model;
      } else {

        Navigator.pop(context);
        return model;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      Navigator.pop(context);
      return null;
    }
  }


  // 2. REGISTER API call

  Future<CommonRegisterModel?> register(context, {required body}) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/signup');

    var result = await http.post(url, body: body);
    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        code: result.statusCode);

    var response = jsonDecode(result.body);
    if (result.statusCode == 200 || result.statusCode == 201) {
      if (response['success'] == true) {
        var model = CommonRegisterModel.fromJson(response);
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return model;
      } else if (response['message']=="The email has already been taken."){
        Fluttertoast.showToast(
          msg: "Email ID provided is already registered with us. Try Login using the same.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return null;
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      Fluttertoast.showToast(
        msg: response['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
      return null;
    }
  }

  //3. Change Password

  changePassword({required body}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/change_password');
    String? token = Utils.prefs!.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "authorization": "Bearer $token"
    };

    var result = await http.post(url, headers: headers, body: jsonEncode(body));
    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        header: headers.toString(),
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);

      if (response['success'] == true) {
        log('RESPONSE ::::: $response');
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      return null;
    }
  }

// Forgot password Flow 3 API
  // 1.   Verfiy Email

  Future<CommonVerifyEmailModel?> forgotVerfiyEmail(context,
      {required body}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/verify-email');

    var result = await http.post(url, body: body);
    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        var model = CommonVerifyEmailModel.fromJson(response);
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return model;
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      var response = jsonDecode(result.body);
      Fluttertoast.showToast(
        msg: response['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
      return null;
    }
  }

  //2  Verfiy OTP

  Future<CommonVerifyOTPModel?> forgotVerfiyOTP(context,
      {required body}) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/verify-otp');

    var result = await http.post(url, body: body);
    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        var model = CommonVerifyOTPModel.fromJson(response);
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return model;
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      var response = jsonDecode(result.body);
      Fluttertoast.showToast(
        msg: response['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
      return null;
    }
  }

  //3  New Request Change Password

  forgotChangePassword(context, {required body}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/forgot/change_password');

    var result = await http.post(url, body: body);
    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
        response: result.body,
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        var model = CommonVerifyOTPModel.fromJson(response);
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return model;
      } else {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      var response = jsonDecode(result.body);
      Fluttertoast.showToast(
        msg: response['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
      return null;
    }
  }
}
