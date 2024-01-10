import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';

import 'package:hotel_kitchen_management_app/view/admin/screens/Order_management/order_status_screen.dart';

import 'package:hotel_kitchen_management_app/view/admin/screens/inventory_screen/inventory_screen.dart';
import 'package:hotel_kitchen_management_app/view/admin/screens/menu_management/menu_management.dart';
import 'package:hotel_kitchen_management_app/view/admin/screens/widgets/custum_dashboard_btn.dart';
import 'package:hotel_kitchen_management_app/controller/admin_home_controller/admin-home_controller.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:provider/provider.dart';

class AdminDashBoardScreen extends StatelessWidget {
  const AdminDashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminController>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              provider.logout(context);
            },
          ),
        ],
        title: Text("Admin"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                    MaterialPageRoute(
                        builder: (context) => OrderStatusScreen()),
                  );
                },
              ),
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 10,
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
      ),
    );
  }
}
