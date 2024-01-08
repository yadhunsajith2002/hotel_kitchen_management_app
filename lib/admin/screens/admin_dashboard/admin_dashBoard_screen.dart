import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';
import 'package:hotel_kitchen_management_app/admin/screens/Order_management/oder_management.dart';
import 'package:hotel_kitchen_management_app/admin/screens/Order_management/order_status_screen.dart';
import 'package:hotel_kitchen_management_app/admin/screens/Order_management/take_order_screen.dart';
import 'package:hotel_kitchen_management_app/admin/screens/inventory_screen/inventory_screen.dart';
import 'package:hotel_kitchen_management_app/admin/screens/menu_management/menu_management.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';

class AdminDashBoardScreen extends StatelessWidget {
  const AdminDashBoardScreen({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            custumManageButton(
              context,
              name: "Order Management",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderStatusScreen()),
                );
              },
            ),
            custumManageButton(
              context,
              name: "Inventory Management",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InventoryManagementScreen()),
                );
              },
            ),
            custumManageButton(
              context,
              name: "Menu Management",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuManagementScreen()),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  InkWell custumManageButton(BuildContext context,
      {void Function()? onTap, String? name}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.yellow,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              name!,
              style: textstyle(
                color: Colors.black,
                fontSize: 20,
                weight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut(context);
    // Navigate to the login screen
  }
}
