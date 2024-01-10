import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:hotel_kitchen_management_app/view/admin/model/menu_model.dart';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  CollectionReference menuCollection =
      FirebaseFirestore.instance.collection('menu');

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isEditing = false;
  String? editingItemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu Items',
          style: textstyle(fontSize: 20, weight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: menuCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  List<MenuItem> menuItems = snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return MenuItem(
                      id: doc.id,
                      name: data['name'],
                      price: data['price'] ?? 0.0,
                    );
                  }).toList();

                  return ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      var item = menuItems[index];
                      return ListTile(
                        title: Text('${item.name} '),
                        subtitle: Text("  \$${item.price.toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _editItem(item);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _removeItem(item.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Item' : 'Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price (\$)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveItem();
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveItem() async {
    String itemName = nameController.text.trim();
    double price = double.tryParse(priceController.text.trim()) ?? 0.0;

    if (isEditing) {
      // Update existing item
      await menuCollection.doc(editingItemId).update({
        'name': itemName,
        'price': price,
      });
    } else {
      // Add new item
      await menuCollection.add({
        'name': itemName,
        'price': price,
      });
    }

    // Clear controllers and flags
    nameController.clear();
    priceController.clear();
    isEditing = false;
    editingItemId = null;
  }

  void _editItem(MenuItem item) {
    setState(() {
      nameController.text = item.name;
      priceController.text = item.price.toString();
      isEditing = true;
      editingItemId = item.id;
    });
    _showAddItemDialog();
  }

  void _removeItem(String itemId) async {
    await menuCollection.doc(itemId).delete();
  }
}
