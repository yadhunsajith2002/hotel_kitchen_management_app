import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_kitchen_management_app/admin/screens/Order_management/oder_management.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';

class TakeOrderScreen extends StatefulWidget {
  const TakeOrderScreen({Key? key}) : super(key: key);

  @override
  _TakeOrderScreenState createState() => _TakeOrderScreenState();
}

class _TakeOrderScreenState extends State<TakeOrderScreen> {
  List<MenuItem> selectedMenuItems = [];
  CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Order'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('menu').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<MenuItem> menuItems = snapshot.data!.docs.map((doc) {
              return MenuItem(
                id: doc.id,
                name: doc['name'],
                price: doc['price'] ?? 0.0,
              );
            }).toList();

            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                // Use a local variable to track the selected state
                bool isSelected = selectedMenuItems.contains(menuItems[index]);

                return InkWell(
                  onTap: () {
                    _handleCheckboxChange(!isSelected, menuItems[index]);
                    setState(() {});
                  },
                  child: Card(
                    color: isSelected ? Colors.yellow : null,
                    child: ListTile(
                      title: Text(
                          '${menuItems[index].name} - \$${menuItems[index].price}'),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            _createOrder(selectedMenuItems);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderManagementScreen(),
                ));
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: kyellow),
            child: Center(
              child: Text(
                "Proceed",
                style: textstyle(
                    color: Colors.black, fontSize: 25, weight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCheckboxChange(bool value, MenuItem item) {
    setState(() {
      if (value) {
        selectedMenuItems.add(item);
      } else {
        selectedMenuItems.remove(item);
      }
    });
  }

  void _createOrder(List<MenuItem> selectedItems) async {
    try {
      // Create a new order document in the "orders" collection
      DocumentReference orderRef =
          await FirebaseFirestore.instance.collection('orders').add({
        'timestamp': FieldValue.serverTimestamp(),
        'items': selectedItems.map((item) {
          return {
            'id': item.id,
            'name': item.name,
            'price': item.price,
          };
        }).toList(),
      });

      // Optional: You can use the orderRef to navigate to the order details screen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OrderDetailsScreen(orderRef.id),
      //   ),
      // );

      // Clear the selected items list
      setState(() {
        selectedMenuItems.clear();
      });
    } catch (e) {
      print('Error creating order: $e');
      // Handle the error as needed
    }
  }
}

class MenuItem {
  final String id;
  final String name;
  final double price;

  MenuItem({required this.id, required this.name, required this.price});
}
