import 'package:discordia5/tabs/login_and_register_form.dart';
import 'package:discordia5/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      logged: false,
      body: LoginAndRegisterForm()
    );
  }
}