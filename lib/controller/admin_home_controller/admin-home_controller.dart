import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/services/auth_services.dart';

class AdminController extends ChangeNotifier {
  void logout(BuildContext context) async {
    await AuthService().signOut(context);

    // Navigate to the login screen
  }
}
