import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/admin/screens/admin_dashboard/admin_dashBoard_screen.dart';
import 'package:hotel_kitchen_management_app/controller/login_controllers/login_controller.dart';
import 'package:hotel_kitchen_management_app/pages/auth/login_screen/login_screen.dart';
import 'package:hotel_kitchen_management_app/pages/chef/chef_home_screen/chef_home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Add a delay of 2 seconds (adjust as needed)
    await Future.delayed(Duration(seconds: 2));

    // Check the role from SharedPreferences
    String? userRole = await _getUserRole();

    // Navigate based on the role
    if (userRole == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashBoardScreen()),
      );
    } else if (userRole == 'chef') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChefHomeScreen()),
      );
    } else {
      // If no role is found, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<String?> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  @override
  Widget build(BuildContext context) {
    // Add your splash screen UI here
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Lottie.asset(
            "assets/animations/Animation - 1704615311874.json",
          ),
        ),
      ),
    );
  }
}
