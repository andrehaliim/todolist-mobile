import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:todolist/components/Dialog.dart';
import 'package:todolist/components/Loading.dart';
import 'package:todolist/models/RegisterModel.dart';
import 'package:todolist/proxys/LoginProxy.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationController = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmation = true;

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width;
    double defaultHeight = MediaQuery.of(context).size.height;
    SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(context: context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leadingWidth: 25,
        title: const Text('', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Container(
        width: defaultWidth,
        height: defaultHeight,
        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const Text(
              'Please enter your details',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Username',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: '',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Name',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: '',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Email',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: '',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Password',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: '',
                  suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      }),
                ),
                obscureText: hidePassword,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Password Confirmation',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: confirmationController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  border: InputBorder.none,
                  hintText: '',
                  suffixIcon: IconButton(
                      icon: Icon(
                        hideConfirmation ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          hideConfirmation = !hideConfirmation;
                        });
                      }),
                ),
                obscureText: hideConfirmation,
              ),
            ),
            const Spacer(),
            Container(
              width: defaultWidth,
              height: defaultHeight * 0.075,
              margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextButton(
                  onPressed: () async {
                    RegisterModel data = RegisterModel(
                        name: nameController.text,
                        password: passwordController.text,
                        confirmation: confirmationController.text,
                        email: emailController.text,
                        username: usernameController.text
                    );
                    showProgressDialog('', dialog, context);
                    bool regis = await register(context, data);
                    hideProgressDialog(dialog);
                    if(regis){
                      showSuccessDialog(context, 'Register', 'User created successfully!');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.black),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
