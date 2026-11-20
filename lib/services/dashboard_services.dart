import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:momworkapp/models/common_dashboard_model.dart';

import '../utils/utils.dart';

class Services {
  // Dashboard API call

  Future<CommonHomeListModel?> homePostList({context, page}) async {
    try {
      var url = Uri.parse(
          'https://nivethaeacademy.in/mystsriya/public/api/posts?page=$page');
      String? token = Utils.prefs!.getString('token');
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        "authorization": "Bearer $token"
      };
      var result = await http.get(url, headers: headers);
      Utils.logApiData(
          url: url.toString(),
          response: result.body,
          header: headers.toString(),
          code: result.statusCode);
      // log(result.body);

      if (result.statusCode == 200 || result.statusCode == 201) {
        var response = jsonDecode(result.body);
        // log(result.body);
        if (response['success'] == true) {
          var model = CommonHomeListModel.fromJson(response);
          return model;
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
          // Navigator.pop(context);
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
        // Navigator.pop(context);
        return null;
      }
    } catch(ex) {
    //  Navigator.pop(context);
      return null;
    }

  }

  // post Detalis Screen
  Future<CommonHomedetailsModel?> homePostDetalis(context, id) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/posts/$id');
    String? token = Utils.prefs!.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "authorization": "Bearer $token"
    };
    var result = await http.get(url, headers: headers);
    Utils.logApiData(
        url: url.toString(),
        response: result.body,
        header: headers.toString(),
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);

      if (response['success'] == true) {
        Navigator.pop(context);
        return CommonHomedetailsModel.fromJson(response);
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
      return null;
    }
  }

  // Like & unlike API

  Future<CommonLikePostModel?> likePostData(context, id) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/posts/likes/$id');
    String? token = Utils.prefs!.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      "authorization": "Bearer $token"
    };
    var result = await http.post(url, headers: headers);
    Utils.logApiData(
        url: url.toString(),
        response: result.body,
        header: headers.toString(),
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);

      if (response['success'] == true) {
        Fluttertoast.showToast(
          msg: response['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return CommonLikePostModel.fromJson(response);
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
        // Navigator.pop(context);
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
      // Navigator.pop(context);
      return null;
    }
  }
}
