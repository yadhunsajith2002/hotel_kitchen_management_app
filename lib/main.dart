import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/controller/create_account_controller/create_acc_controller.dart';
import 'package:hotel_kitchen_management_app/controller/login_controllers/login_controller.dart';
import 'package:hotel_kitchen_management_app/firebase_options.dart';
import 'package:hotel_kitchen_management_app/pages/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginController(),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateAccountController(),
        ),
      ],
      child: MaterialApp(
        title: 'Awesome App',
        theme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }
}
