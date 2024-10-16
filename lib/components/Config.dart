import 'package:flutter/material.dart';
import 'package:todolist/models/UserModel.dart';

class Config with ChangeNotifier {
  String serverAddress = const String.fromEnvironment(
      "API_SERVER",defaultValue: 'https://b7c4-182-253-124-103.ngrok-free.app/api');
  int serverTimeout = 60;
  UserModel currentUser = UserModel.empty();
  String token = '';
  Color white = const Color(0xFFFFFFFF);
  Color greyWhite = const Color(0xFFC0C0C0);
  Color grey = const Color(0xFF808080);
  Color greyBlack = const Color(0xFF404040);
  Color black = const Color(0xFF000000);
}