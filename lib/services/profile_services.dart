import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:momworkapp/models/common_auth_model.dart';
import 'package:momworkapp/models/common_profile_model.dart';
import 'package:momworkapp/models/wallet_model.dart';

import '../utils/utils.dart';

class Services {
  // Get Profile

  Future<CommonProfileListModel?> getProfile(context) async {
    try {
      var url =
      Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/profile');
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
          var model = CommonProfileListModel.fromJson(response);
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
    } catch (ex) {
      Navigator.pop(context);
      return null;
    }

  }

  // Edite Profile

  Future<CommonEditeProfileListModel?> updateProfile(context,
      {required body, imagePath}) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/profile');

    var request = http.MultipartRequest('POST', url);

    String? token = Utils.prefs!.getString('token');
    if (imagePath != null) {
      File imageFile = File(imagePath ??
          ''); // Assuming imagePath is a String containing the file path
      var stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image', // Field name in the API
        stream,
        length,
        filename: imageFile.path.split('/').last,
      );

      request.files.add(multipartFile);
    }
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
      //  Navigator.pop(context);
        Navigator.pop(context);
        return CommonEditeProfileListModel.fromJson(data);
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
// Bank Details carete & update

  Future<CommonBankDeatilsModel?> bankDetailsUpdate(BuildContext context,
      {required body}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/user-detail');
    String? token = Utils.prefs!.getString('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
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
        Navigator.pop(context);
        log('RESPONSE ::::: $response');
        var model = CommonBankDeatilsModel.fromJson(response);
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

  Future<WalletModel?> getUserWalletHistory() async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/profile/wallet');
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
        var model = WalletModel.fromJson(response);
        return model;
      }
      return null;
    } else if (result.statusCode == 401) {
      Utils.logout();
      return null;
    }
    return null;
  }
}
