import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';
import 'package:hotel_kitchen_management_app/pages/auth/create_account/create_account_screen.dart';
import 'package:hotel_kitchen_management_app/pages/chef/chef_home_screen/chef_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false; // Track loading state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> login(BuildContext context) async {
    if (_validate()) {
      // Reset error messages
      _resetErrors();

      // Set loading state to true
      isLoading = true;
      notifyListeners();

      // Call the AuthService for login
      bool loginSuccess = await AuthService().login(
        emailController.text.trim(),
        passwordController.text.trim(),
        context,
      );

      // Set loading state to false after the login attempt
      isLoading = false;
      notifyListeners();

      if (!loginSuccess) {
        // Show a Snackbar
        final snackBar = SnackBar(
          content: Text('Email or password is incorrect'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Set the user role in SharedPreferences
        await setUserRole('chef');

        // Navigate to the home screen upon successful login
        _navigateToHomeScreen(context);
      }
    }
  }

  Future<void> clearUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }

  Future<void> setUserRole(String role) async {
    // Store the selected role in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  void _navigateToHomeScreen(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChefHomeScreen()),
    );
  }

  void goToCreateAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountScreen()),
    );
  }

  bool _validate() {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      // Set error messages based on validation errors
      _setErrorMessages(
        'Enter a valid email address',
        'Enter a password',
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

  Future<void> setRoleToAdmin() async {
    // Set the user role to 'admin' in SharedPreferences
    await setUserRole('admin');
  }
}
