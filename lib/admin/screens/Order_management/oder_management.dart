import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; // Import the awesome_notifications package

import 'package:hotel_kitchen_management_app/admin/screens/admin_dashboard/admin_dashBoard_screen.dart';

import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:lottie/lottie.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<Order> orders = [];
  List<Chef> chefs = []; // List to store chefs from Firestore
  Chef? selectedChef; // Currently selected chef
  void initState() {
    super.initState();
    // Initialize Awesome Notifications in the initState method
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('orders').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            orders = snapshot.data!.docs.map((doc) {
              // Ensure 'items' is a List<Map>
              List<Map<String, dynamic>> items = [];

              try {
                dynamic itemsData = doc['items'];
                if (itemsData is List) {
                  items = List<Map<String, dynamic>>.from(itemsData);
                }
              } catch (e) {
                print("Error parsing 'items' in document ${doc.id}: $e");
              }

              // Debugging print statements
              print('Order ID: ${doc.id}');

              return Order(
                id: doc.id,
                items: items,
              );
            }).toList();

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ordered Items',
                          style: textstyle(
                              color: Colors.white,
                              fontSize: 25,
                              weight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orders[index].items.map((item) {
                              String name = item['name'];
                              // double price = item['price'].toDouble();
                              // String id = item['id'];
                              return Text(' $name ');
                            }).toList(),
                          ),
                        ),
                      ],
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
            showDialog(
              context: context,
              builder: (context) {
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chefs')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      chefs = snapshot.data!.docs.map((doc) {
                        // Check if 'chefName' field exists in the document
                        if (doc['chefName'] != null) {
                          return Chef(id: doc.id, name: doc['chefName']);
                        } else {
                          // Handle the case where 'chefName' field is missing
                          print(
                              "Warning: 'chefName' field is missing in document ${doc.id}");
                          return Chef(id: doc.id, name: 'N/A');
                        }
                      }).toList();

                      return Center(
                        child: Dialog(
                          child: Container(
                            height: 300,
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Select Chef"),
                                SizedBox(height: 20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: chefs.length,
                                    itemBuilder: (context, chefIndex) {
                                      Chef chef = chefs[chefIndex];
                                      return InkWell(
                                        onTap: () {},
                                        child: Card(
                                          child: ListTile(
                                            title: Text(chef.name),
                                            onTap: () async {
                                              BuildContext
                                                  dialogContext; // Store the reference to the context

                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  dialogContext =
                                                      context; // Assign the context when the dialog is created

                                                  return Center(
                                                    child: Lottie.asset(
                                                      "assets/animations/Animation - 1704710384975.json",
                                                    ),
                                                  );
                                                },
                                              );

                                              // Assume that the assignment logic is done here, replace it with your actual logic
                                              // For example, you might want to save the assigned orders to Firestore
                                              // Replace the following lines with your actual logic

                                              // Get the selected chef's ID
                                              String selectedChefId = chef.id;

                                              // Get the list of assigned orders (replace it with your actual data structure)
                                              List<Map<String, dynamic>>
                                                  assignedOrders =
                                                  orders[chefIndex].items;

                                              // Save the assigned orders to Firestore with the selected chef's ID
                                              await saveAssignedOrders(
                                                  selectedChefId,
                                                  chef.name,
                                                  assignedOrders);

                                              // Simulate an asynchronous operation (replace it with your logic)
                                              await Future.delayed(
                                                  Duration(seconds: 2));
                                              dialogContext = context;
                                              Navigator.pop(
                                                  dialogContext); // Close the dialog using the stored context

                                              // Navigate to ChefHomeScreen after the assignment is done
                                              Navigator.pushReplacement(
                                                dialogContext,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashBoardScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.yellow),
            child: Center(
              child: Text(
                "Confirm",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveAssignedOrders(String chefId, String chefName,
      List<Map<String, dynamic>> assignedOrders) async {
    print('Saving assigned orders...');
    await FirebaseFirestore.instance.collection('assigned_orders').add({
      'chefId': chefId,
      'chefName': chefName,
      'orders': assignedOrders,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('Notification created...');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: 'New Order Arrived',
        body: 'You have a new order assigned to you.',
        bigPicture: 'asset://assets/shutterstock_649541308_20191010160155.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }
}

class Order {
  final String id;
  final List<Map<String, dynamic>> items;

  Order({
    required this.id,
    required this.items,
  });
}

class MenuItem {
  final String id;
  final String name;
  final double price;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
  });
}

class Chef {
  final String id;
  final String name;

  Chef({required this.id, required this.name});
}
