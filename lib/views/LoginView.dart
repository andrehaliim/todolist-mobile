import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:todolist/components/Config.dart';
import 'package:todolist/components/Loading.dart';
import 'package:todolist/proxys/LoginProxy.dart';
import 'package:todolist/views/MenuView.dart';
import 'package:todolist/views/RegisterView.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;
  bool disabledLogin = false;
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(context: context);
    int currentYear = DateTime.now().year;
    Config config = Provider.of<Config>(context);
    double defaultHeight = MediaQuery.of(context).size.height;
    double defaultWidth = MediaQuery.of(context).size.width;

    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: defaultHeight/16,),
                          Image.asset('assets/images/logo.png'),
                          SizedBox(height: defaultHeight/12,),
                          SizedBox(
                            width: defaultWidth,
                            child: const Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(color: config.greyWhite, borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Username',
                                labelStyle: TextStyle(color: config.black, fontWeight: FontWeight.bold),
                                hintText: 'Enter your username',
                                prefixIcon: Icon(Icons.person, color: config.black),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: BoxDecoration(color: config.greyWhite, borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Password',
                                labelStyle: TextStyle(color: config.black, fontWeight: FontWeight.bold),
                                hintText: 'Enter your password',
                                prefixIcon: Icon(Icons.lock, color: config.black),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure ? Icons.visibility : Icons.visibility_off,
                                      color: config.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    }),
                              ),
                              obscureText: _isObscure,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: defaultWidth,
                            height: defaultHeight * 0.075,
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: TextButton(
                                onPressed: disabledLogin
                                    ? null
                                    : () async {

                                  setState(() {
                                    disabledLogin = true;
                                  });
                                  showProgressDialog('', dialog, context);
                                  bool enter = await login(context, usernameController.text, passwordController.text);
                                  hideProgressDialog(dialog);
                                  setState(() {
                                    disabledLogin = false;
                                  });

                                  if (enter) {
                                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('uname', usernameController.text);
                                    await prefs.setString('pw', passwordController.text);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MenuView(),
                                      ),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => config.black),
                                  shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                                ),
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                                )),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Center(
                                  child: Text(
                                    'Ⓒ $currentYear Andre Haliim Kurniawan \n v${packageInfo.version}',
                                    style: TextStyle(
                                      color: config.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ))),
                          SizedBox(
                            width: defaultWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't Have an Account?"),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: const Duration(milliseconds: 300),
                                            reverseDuration: const Duration(milliseconds: 300),
                                            type: PageTransitionType.rightToLeft,
                                            alignment: Alignment.center,
                                            child: const RegisterView()));
                                  },
                                  child: const Text("Register", style: TextStyle(color: Colors.blue)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
