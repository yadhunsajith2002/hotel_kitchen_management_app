import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/admin/screens/admin_home/admin_home.dart';
import 'package:hotel_kitchen_management_app/controller/login_controllers/login_controller.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the LoginController instance
    final loginController = Provider.of<LoginController>(context);

    return Form(
      key: loginController.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "Login",
              style: textstyle(
                  fontSize: 20, color: Colors.white, weight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: loginController.emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: loginController.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a password';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                // Check isLoading before calling login
                if (!loginController.isLoading) {
                  await loginController.setUserRole('chef');
                  await loginController.login(context);
                }
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: loginController.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an Account?'),
                TextButton(
                  onPressed: () {
                    loginController.goToCreateAccount(context);
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await loginController.setRoleToAdmin();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => AdminHomeScreen(),
                    ),
                    (route) => false);
              },
              child: Text('Admin '),
            ),
          ],
        ),
      ),
    );
  }
}
