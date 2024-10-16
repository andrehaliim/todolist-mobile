import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/components/Loading.dart';
import 'package:todolist/components/Config.dart';
import 'package:todolist/proxys/LoginProxy.dart';
import 'package:todolist/views/LoginView.dart';
import 'package:todolist/views/MenuView.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Config())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _futureCheck;

  @override
  void initState() {
    super.initState();
    _futureCheck = checkSharedPreference(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _futureCheck,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          } else if (snapshot.hasData) {
            bool check = snapshot.data!;
            if (check) {
              return MenuView();
            } else {
              return const LoginView();
            }
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}

Future<bool> checkSharedPreference(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? name = prefs.getString('uname');
  final String? pass = prefs.getString('pw');
  if (name != null && pass != null) {
    bool logins = await login(context, name, pass);
    return logins;
  }
  return false;
}
