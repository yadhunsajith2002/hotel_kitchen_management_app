import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/controller/login_controllers/login_controller.dart';
import 'package:hotel_kitchen_management_app/pages/auth/login_screen/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginController controller = LoginController();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print('Error logging in: $e');
      // Handle login error
      // Display a snackbar or other UI feedback
      return false;
    }
  }

  Future<void> createAccount(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('Error creating account: $e');
      // Handle registration error
      // Display a snackbar or other UI feedback
    }
  }

  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  Future<void> signOut(BuildContext context) async {
    // Add the logic to sign out here
    // For example, using Firebase Authentication:
    await FirebaseAuth.instance.signOut();
    await controller.clearUserRole();

    // Navigate to the login screen upon successful sign out
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
        (route) => false);
  }
}
