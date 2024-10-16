import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:todolist/components/Config.dart';
import 'package:todolist/components/Dialog.dart';
import 'package:todolist/models/TodoListModel.dart';

Future<List<TodoListModel>> getTodoList(BuildContext context) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  final url = Uri.parse('${config.serverAddress}/todolist');
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
      List<TodoListModel> list = <TodoListModel>[];

      for (var data in jsonData['data']) {
        list.add(TodoListModel.fromJson(data));
      }
      return list;
    } else {
      throw showFailedDialog(context, 'Todo List', jsonData['message']);
    }
  } catch (error) {
    debugPrint(error.toString());
    throw showFailedDialog(context, 'Todo List', 'Connection Error');
  }
}

Future<bool>createTodoList(BuildContext context, String title, String text) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  Map<String, dynamic> parameter = {
    "user_id": config.currentUser.id,
    "title": title,
    "text" : text
  };
  String jsonBody = json.encode(parameter);

  final url = Uri.parse('${config.serverAddress}/todolist');
  try {
    final response = await ioClient.post(url, body: jsonBody, headers: {
      'Authorization': 'Bearer ${config.token}',
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
      await showFailedDialog(context, 'Create Todo', data['message']);
      return false;
    }
  } catch (error) {
    debugPrint('Error: ${error.toString()}');
    await showFailedDialog(context, 'Create Todo', 'Connection Failed');
    return false;
  }
}

Future<bool>deleteTodoList(BuildContext context, int id) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  final url = Uri.parse('${config.serverAddress}/todolist/$id');
  try {
    final response = await ioClient.delete(url, headers: {
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
      return true;
    } else {
      await showFailedDialog(context, 'Delete Todo', data['message']);
      return false;
    }
  } catch (error) {
    debugPrint('Error: ${error.toString()}');
    await showFailedDialog(context, 'Delete Todo', 'Connection Failed');
    return false;
  }
}

Future<bool>updateTodoList(BuildContext context, String title, String text, int id) async {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
  IOClient ioClient = IOClient(httpClient);
  Config config = Provider.of<Config>(context, listen: false);

  Map<String, dynamic> parameter = {
    "title": title,
    "text" : text
  };
  String jsonBody = json.encode(parameter);

  final url = Uri.parse('${config.serverAddress}/todolist/$id');
  try {
    final response = await ioClient.put(url, body: jsonBody, headers: {
      'Authorization': 'Bearer ${config.token}',
      'Content-Type': 'application/json',
    }).timeout(Duration(seconds: config.serverTimeout));

    // Debug
    debugPrint('Url: $url');
    debugPrint('Parameter: $jsonBody');
    debugPrint('Response Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      await showSuccessDialog(context, 'Update Todo', data['message']);
      return true;
    } else {
      await showFailedDialog(context, 'Update Todo', data['message']);
      return false;
    }
  } catch (error) {
    debugPrint('Error: ${error.toString()}');
    await showFailedDialog(context, 'Update Todo', 'Connection Failed');
    return false;
  }
}

