import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/global/widgets/custum_appBar.dart';
import 'package:hotel_kitchen_management_app/pages/auth/login_screen/login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(),
      ),
    );
  }
}
