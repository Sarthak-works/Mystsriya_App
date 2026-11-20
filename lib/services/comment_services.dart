import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:momworkapp/models/common_comment_model.dart';

import '../utils/utils.dart';

class CommentServices {
  // Comment Add

  commentAdd(context, {required body, required postId}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/posts/comment/$postId');

    print('Dataaaaaaaaaa ::::$body');
    print(url);
    String? token = Utils.prefs!.getString('token');
    Map<String, String> headers = {"authorization": "Bearer $token"};
    var result = await http.post(url, body: body, headers: headers);

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
        Navigator.pop(context);
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

  // Comment List Get

  Future<CommonCommentListModel?> commentList(context,
      {required postId, page}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/posts/comment/$postId?page=$page');

    print(url);
    String? token = Utils.prefs!.getString('token');
    Map<String, String> headers = {"authorization": "Bearer $token"};
    var result = await http.get(url, headers: headers);

    Utils.logApiData(
        url: url.toString(),
        response: result.body,
        header: headers.toString(),
        code: result.statusCode);

    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        var model = CommonCommentListModel.fromJson(response);
        return model;
      } else {
        return null;
      }
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      return null;
    }
  }
}
