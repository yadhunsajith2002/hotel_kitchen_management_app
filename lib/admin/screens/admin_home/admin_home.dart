import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
        title: Text("Admin"),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut(context);
    // Navigate to the login screen
  }
}
