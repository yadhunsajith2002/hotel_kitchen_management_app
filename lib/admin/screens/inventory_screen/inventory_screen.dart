import 'package:flutter/material.dart';

class InventoryManagementScreen extends StatefulWidget {
  @override
  _InventoryManagementScreenState createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  List<InventoryItem> inventoryItems = [
    InventoryItem(id: 1, name: 'Flour', quantity: 10),
    InventoryItem(id: 2, name: 'Sugar', quantity: 5),
    InventoryItem(id: 1, name: 'Wheat', quantity: 10),
    InventoryItem(id: 2, name: 'Milk', quantity: 5),
    InventoryItem(id: 1, name: 'Maida', quantity: 10),
    InventoryItem(id: 2, name: 'rawa', quantity: 5),

    InventoryItem(id: 1, name: 'Meat', quantity: 10),
    InventoryItem(id: 2, name: 'Beef', quantity: 5),
    // Add more sample inventory items as needed
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  bool isEditing = false;
  int? editingItemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventory Items',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: inventoryItems.length,
                itemBuilder: (context, index) {
                  var item = inventoryItems[index];
                  return ListTile(
                    title: Text('${item.name} - ${item.quantity} units'),
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
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantity'),
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

  void _saveItem() {
    String itemName = nameController.text.trim();
    String quantityText = quantityController.text.trim();
    int quantity = quantityText.isEmpty ? 0 : int.parse(quantityText);

    if (isEditing) {
      // Update existing item
      int index = inventoryItems.indexWhere((item) => item.id == editingItemId);
      if (index != -1) {
        setState(() {
          inventoryItems[index].name = itemName;
          inventoryItems[index].quantity = quantity;
        });
      }
    } else {
      // Add new item
      setState(() {
        inventoryItems.add(InventoryItem(
          id: DateTime.now().millisecondsSinceEpoch,
          name: itemName,
          quantity: quantity,
        ));
      });
    }

    // Clear controllers and flags
    nameController.clear();
    quantityController.clear();
    isEditing = false;
    editingItemId = null;
  }

  void _editItem(InventoryItem item) {
    setState(() {
      nameController.text = item.name;
      quantityController.text = item.quantity.toString();
      isEditing = true;
      editingItemId = item.id;
    });
    _showAddItemDialog();
  }

  void _removeItem(int itemId) {
    setState(() {
      inventoryItems.removeWhere((item) => item.id == itemId);
    });
  }
}

class InventoryItem {
  final int id;
  String name;
  int quantity;

  InventoryItem({required this.id, required this.name, required this.quantity});
}
