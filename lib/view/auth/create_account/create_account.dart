import 'package:flutter/material.dart';

import 'package:hotel_kitchen_management_app/controller/create_account_controller/create_acc_controller.dart';

import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CreateAccountForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the CreateAccountController instance
    final provider = Provider.of<AuthController>(context);

    return Form(
      key: provider.CformKey,
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
              controller: provider.chefNameController,
              decoration: InputDecoration(
                  labelText: 'Chef\'s Name', // Add this line
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter the chef\'s name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: provider.emailController,
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
              controller: provider.passwordController,
              obscureText: provider.isShow,
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                      onTap: () {
                        provider.obscureTextView();
                      },
                      child: Icon(provider.isShow
                          ? Icons.visibility
                          : Icons.visibility_off)),
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
                // Start loading
                provider.setLoading(true);

                // Call the createAccount method
                await provider.createAccount(context);

                // Stop loading
                provider.setLoading(false);
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: provider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Create Account',
                          style: textstyle(
                              fontSize: 18,
                              color: Colors.black,
                              weight: FontWeight.bold),
                        ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an Account?'),
                TextButton(
                  onPressed: () {
                    provider.goToCreateAccount(context);
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
