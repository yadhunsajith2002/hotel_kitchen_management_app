import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/admin/screens/admin_home/admin_home.dart';
import 'package:hotel_kitchen_management_app/controller/create_account_controller/create_acc_controller.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:provider/provider.dart';

class CreateAccountForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the CreateAccountController instance
    final createAccountController =
        Provider.of<CreateAccountController>(context);

    return Form(
      key: createAccountController.CformKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "Create An Account",
              style: textstyle(
                  fontSize: 20, color: Colors.white, weight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: createAccountController.emailController,
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
            SizedBox(height: 20),
            TextFormField(
              controller: createAccountController.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) {
                if (value!.isEmpty || value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                createAccountController.createAccount(context);
              },
              child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Text(
                    'Create Account',
                    style: textstyle(
                        fontSize: 18,
                        color: Colors.black,
                        weight: FontWeight.bold),
                  ))),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an Account?'),
                TextButton(
                  onPressed: () {
                    createAccountController.goToCreateAccount(context);
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}