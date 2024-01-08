import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';
import 'package:hotel_kitchen_management_app/pages/auth/login_screen/login_screen.dart';

class ChefHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }

  // Function to handle logout
  void _logout(BuildContext context) async {
    await AuthService().signOut(context);
    // Navigate to the login screen
  }
}
