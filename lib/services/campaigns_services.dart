import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';
import 'package:momworkapp/models/common_campaigns_model.dart';

import '../utils/utils.dart';

class CampaignsServices {
// 1 Campaigns List

  Future<CommonCampaignsListModel?> campaignsListData({context, type}) async {
    Map<String, dynamic> queryParams={};
    if (type.toString().isNotEmpty)
      queryParams = {
      'type': type
      };
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/campaigns').replace(queryParameters: queryParams);
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
      if (response['success'] == true) {
        try {
          var model = CommonCampaignsListModel.fromJson(response);
          return model;
        }

        catch (ex){
          print("dsf ${ex.toString()}");
        }

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

// campaigns Details

  Future<CommonCampaignsDetailsModel?> campaignsDetailsData(
      {context, id}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/campaigns/$id');

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
        var model = CommonCampaignsDetailsModel.fromJson(response);
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

  // campaings Task Details

  Future<CommonCampaignsTaskDetailsModel?> campaignsTaskDetailsData(
      {context, id}) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/tasks/$id');

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
        var model = CommonCampaignsTaskDetailsModel.fromJson(response);
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

  // compleTask API

  taskCompleteAPI(context, {required body, imagePath}) async {
    var url =
        Uri.parse('https://nivethaeacademy.in/mystsriya/public/api/tasks');

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
    request.headers['Content-Type'] = "application/json";
    request.fields.addAll(body);

    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    Utils.logApiData(
        url: url.toString(),
        body: body.toString(),
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
          (route) => false,
        );
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

  // Finish Task API

  finishtask({context, required id}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/campaigns/finish/$id');

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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CustomBottomTabBar()),
            (route) => false);
        return null;
      } else if (result.statusCode == 401) {
        Utils.logout();
        return null;
      } else {
        Navigator.pop(context);
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
    } else {
      return null;
    }
  }

  // Campaigns Apply

  campaignsApply({context, required id}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/campaigns/apply/$id');

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
        return null;
      }
    } else {
      return null;
    }
  }

  // Past

  Future<CommonCampaignsListModel?> pastCampaignsListData({context}) async {
    var url = Uri.parse(
        'https://nivethaeacademy.in/mystsriya/public/api/campaigns/pastCampaigns');
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
    // log(result.body);
    if (result.statusCode == 200 || result.statusCode == 201) {
      var response = jsonDecode(result.body);
      if (response['success'] == true) {
        var model = CommonCampaignsListModel.fromJson(response);
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
}
