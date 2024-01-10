import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_kitchen_management_app/view/admin/screens/Order_management/oder_management.dart';
import 'package:hotel_kitchen_management_app/model/menu_model/menu_model.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';

import 'dart:async';

class TakeOrderScreen extends StatefulWidget {
  const TakeOrderScreen({Key? key}) : super(key: key);

  @override
  _TakeOrderScreenState createState() => _TakeOrderScreenState();
}

class _TakeOrderScreenState extends State<TakeOrderScreen> {
  List<MenuItemModel> selectedMenuItems = [];
  CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('orders');

  late StreamController<List<MenuItemModel>> _menuItemsController;

  @override
  void initState() {
    super.initState();
    _menuItemsController = StreamController<List<MenuItemModel>>.broadcast();
    _fetchMenuItems();
  }

  @override
  void dispose() {
    _menuItemsController.close();
    super.dispose();
  }

  void _fetchMenuItems() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('menu').get();
      List<MenuItemModel> menuItems = querySnapshot.docs.map((doc) {
        return MenuItemModel(
          id: doc.id,
          name: doc['name'],
          price: doc['price'] ?? 0.0,
        );
      }).toList();

      _menuItemsController.add(menuItems);
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Order'),
      ),
      body: StreamBuilder<List<MenuItemModel>>(
        stream: _menuItemsController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<MenuItemModel> menuItems = snapshot.data ?? [];

            return ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                MenuItemModel menuItem = menuItems[index];
                bool isSelected = selectedMenuItems.contains(menuItem);

                return CheckboxTile(
                  item: menuItem,
                  isSelected: isSelected,
                  onChanged: (value) {
                    _handleCheckboxChange(value!, menuItem);
                  },
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
              ),
            );
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

  void _handleCheckboxChange(bool value, MenuItemModel item) {
    setState(() {
      if (value) {
        selectedMenuItems.add(item);
      } else {
        selectedMenuItems.remove(item);
      }
    });
  }

  void _createOrder(List<MenuItemModel> selectedItems) async {
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

      setState(() {
        selectedMenuItems.clear();
      });
    } catch (e) {
      print('Error creating order: $e');
    }
  }
}

class CheckboxTile extends StatelessWidget {
  final MenuItemModel item;
  final bool isSelected;
  final void Function(bool?)? onChanged;

  const CheckboxTile({
    required this.item,
    required this.isSelected,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        title: Text(
          '${item.name} - \$${item.price}',
        ),
        value: isSelected,
        onChanged: onChanged);
  }
}
