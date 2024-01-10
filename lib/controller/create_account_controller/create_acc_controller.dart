import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/view/auth/login_screen/login_screen.dart';
import 'package:hotel_kitchen_management_app/view/chef/screen/chef_home_screen/chef_home_screen.dart';
import 'package:hotel_kitchen_management_app/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController chefNameController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? selectedRole;
  bool isLoading = false; // Add isLoading variable

  bool isShow = false;

  void obscureTextView() {
    isShow = !isShow;
    notifyListeners();
  }

  final GlobalKey<FormState> CformKey = GlobalKey<FormState>();

  Future<void> createAccount(BuildContext context) async {
    if (_validate()) {
      try {
        // Start loading
        setLoading(true);

        // Create an account in Firebase Authentication
        await AuthService().createAccount(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        // Store chef information in Firestore
        await _storeChefInFirestore();

        // Navigate to the appropriate screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ChefHomeScreen()),
          (route) => false,
        );
      } catch (e) {
        print("Error creating account: $e");
        // Handle errors as needed
      } finally {
        // Stop loading
        setLoading(false);
      }
    }
  }

  Future<void> _storeChefInFirestore() async {
    try {
      // Get the current user
      // var user = await AuthService().getCurrentUser();

      // Store chef information in Firestore with automatically generated ID
      var chefRef = FirebaseFirestore.instance.collection('chefs').doc();
      await chefRef.set({
        'id': chefRef.id,
        'chefName': chefNameController.text.trim(),
        'email': emailController.text.trim(),
        // Add other chef information if needed
      });
    } catch (e) {
      print("Error storing chef in Firestore: $e");
      // Handle errors as needed
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

  void setLoading(bool value) {
    // Set loading state
    isLoading = value;
    notifyListeners();
  }

  void _setErrorMessages(String email, String password) {
    // Set error messages
    emailError = email;
    passwordError = password;
    notifyListeners();
  }

  void goToCreateAccount(BuildContext context) {
    // Navigate to the login screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
