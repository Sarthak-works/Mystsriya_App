import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';

import '../utils/utils.dart';

class Services {
  // Create Post
  createPostData(context, {required body, required image}) async {
    var url = Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/posts');

    var request = http.MultipartRequest('POST', url);

    print(image);

    if (image != null) {
      var multipartFile = await http.MultipartFile.fromPath('image', image);
      request.files.add(multipartFile);
    }

    String? token = Utils.prefs!.getString('token');
    request.headers['authorization'] = "Bearer $token";
    request.fields.addAll(body);
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    Utils.logApiData(
        url: url.toString(),
        body: request.fields.toString(),
        response: responseString,
        header: request.headers.toString(),
        code: response.statusCode);

    var data = jsonDecode(responseString);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CustomBottomTabBar()),
            (route) => false);
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
    } else if (response.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      Fluttertoast.showToast(
        msg: data['message'],
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

  // User Edit Post

  editPostData(context,
      {conteex, required body, required image, required postId}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/posts/update/$postId');

    var request = http.MultipartRequest('POST', url);

    print('body=====$body');
    print('image=====$image');

    if (image != null) {
      var multipartFile = await http.MultipartFile.fromPath('image', image);
      request.files.add(multipartFile);
    }

    String? token = Utils.prefs!.getString('token');
    request.headers['authorization'] = "Bearer $token";
    request.fields.addAll(body);

    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    Utils.logApiData(
        url: url.toString(),
        body: request.fields.toString(),
        response: responseString,
        header: request.headers.toString(),
        code: response.statusCode);

    var data = jsonDecode(responseString);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (data['success'] == true) {
        Fluttertoast.showToast(
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
        Navigator.pop(context);
        return null;
      } else {
        Fluttertoast.showToast(
          msg: data['message'],
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
    } else if (response.statusCode == 401) {
      Utils.logout();
      return null;
    } else {
      Fluttertoast.showToast(
        msg: data['message'],
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
