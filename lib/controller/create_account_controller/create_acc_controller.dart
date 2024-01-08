import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';
import 'package:hotel_kitchen_management_app/admin/screens/admin_home/admin_home.dart';
import 'package:hotel_kitchen_management_app/pages/auth/login_screen/login_screen.dart';
import 'package:hotel_kitchen_management_app/pages/chef_home_screen/chef_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? selectedRole;

  final GlobalKey<FormState> CformKey = GlobalKey<FormState>();

  Future<void> createAccount(BuildContext context) async {
    if (_validate()) {
      // Reset error messages
      _resetErrors();

      // Call the AuthService to create an account
      await AuthService().createAccount(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChefHomeScreen(),
        ),
        (route) => false,
      );
    }
  }

  bool _validate() {
    bool isValid = CformKey.currentState!.validate();

    if (!isValid) {
      // Set error messages based on validation errors
      _setErrorMessages(
        'Enter a valid email address',
        'Password must be at least 6 characters',
      );
    }

    return isValid;
  }

  void _resetErrors() {
    // Reset error messages
    emailError = null;
    passwordError = null;
    notifyListeners();
  }

  void _setErrorMessages(String email, String password) {
    // Set error messages
    emailError = email;
    passwordError = password;
    notifyListeners();
  }

  void goToCreateAccount(BuildContext context) {
    // Navigate to the create account screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
