import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:todolist/components/Config.dart';
import 'package:todolist/components/Dialog.dart';
import 'package:todolist/models/RegisterModel.dart';
import 'package:todolist/models/UserModel.dart';

Future<bool>login(BuildContext context, String username, String password) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  Map<String, dynamic> parameter = {"username": username, "password": password};
  String jsonBody = json.encode(parameter);

  final url = Uri.parse('${config.serverAddress}/auth/login');
  try {
    final response = await ioClient.post(url, body: jsonBody, headers: {
      'Content-Type': 'application/json',
    }).timeout(Duration(seconds: config.serverTimeout));

    // Debug
    debugPrint('Url: $url');
    debugPrint('Parameter: $jsonBody');
    debugPrint('Response Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      config.token = data['data']['token'];
      return true;
    } else {
      await showFailedDialog(context, 'Login', data['message']);
      return false;
    }
  } catch (error) {
    debugPrint('Error: ${error.toString()}');
    await showFailedDialog(context, 'Login', 'Connection Failed');
    return false;
  }
}

Future<bool>logout(BuildContext context) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  final url = Uri.parse('${config.serverAddress}/auth/logout');
  try {
    final response = await ioClient.post(url, headers: {
      'Authorization': 'Bearer ${config.token}',
      'Content-Type': 'application/json',
    }).timeout(Duration(seconds: config.serverTimeout));

    // Debug
    debugPrint('Url: $url');
    //debugPrint('Parameter: $jsonBody');
    debugPrint('Response Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      await showSuccessDialog(context, 'Logout', data['message']);
      return true;
    } else {
      await showFailedDialog(context, 'Logout', data['message']);
      return false;
    }
  } catch (error) {
    debugPrint('Error: ${error.toString()}');
    await showFailedDialog(context, 'Logout', 'Connection Failed');
    return false;
  }
}

Future<bool>register(BuildContext context, RegisterModel registerModel) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  Map<String, dynamic> parameter = {
    "username": registerModel.username,
    "name" : registerModel.name,
    "email" : registerModel.email,
    "password": registerModel.password,
    "confirmation": registerModel.confirmation
  };
  String jsonBody = json.encode(parameter);

  final url = Uri.parse('${config.serverAddress}/user');
  try {
    final response = await ioClient.post(url, body: jsonBody, headers: {
      'Content-Type': 'application/json',
    }).timeout(Duration(seconds: config.serverTimeout));

    // Debug
    debugPrint('Url: $url');
    debugPrint('Parameter: $jsonBody');
    debugPrint('Response Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      await showFailedDialog(context, 'Register', data['message']);
      return false;
    }
  } catch (error) {
    debugPrint('Error: ${error.toString()}');
    await showFailedDialog(context, 'Register', 'Connection Failed');
    return false;
  }
}

Future<UserModel> getUserInfo(BuildContext context) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  final url = Uri.parse('${config.serverAddress}/auth/me');
  try {
    final response = await ioClient.get(url, headers: {
      'Authorization': 'Bearer ${config.token}',
      'Content-Type': 'application/json',
    }).timeout(Duration(seconds: config.serverTimeout));

    // Debug
    debugPrint(url.toString());
    debugPrint(response.statusCode.toString());
    debugPrint(response.body);
    final jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      config.currentUser = UserModel.fromJson(jsonData['data']);
      return UserModel.fromJson(jsonData['data']);
    } else {
      throw showFailedDialog(context, 'User Info', jsonData['message']);
    }
  } catch (error) {
    debugPrint(error.toString());
    throw showFailedDialog(context, 'User Info', 'Connection Error');
  }
}
