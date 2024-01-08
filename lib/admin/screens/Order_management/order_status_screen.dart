import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/admin/screens/Order_management/take_order_screen.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OrderStatusCard(
              status: 'New Order',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TakeOrderScreen(),
                ));
              },
            ),
            SizedBox(height: 20),
            OrderStatusCard(
              status: 'Pending',
            ),
            SizedBox(height: 20),
            OrderStatusCard(
              status: 'Completed',
            ),
          ],
        ),
      ),
    );
  }
}

class OrderStatusCard extends StatelessWidget {
  final String status;
  final void Function()? onTap;

  const OrderStatusCard({
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kyellow,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 200,
          height: 100,
          child: Center(
            child: Text(
              status,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
