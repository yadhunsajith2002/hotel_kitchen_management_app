import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; // Import the awesome_notifications package

import 'package:hotel_kitchen_management_app/view/admin/screens/admin_dashboard/admin_dashBoard_screen.dart';
import 'package:hotel_kitchen_management_app/model/chef_model/chef_model.dart';
import 'package:hotel_kitchen_management_app/model/order_model/order_model.dart';

import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:lottie/lottie.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<OrderModel> orders = [];
  List<ChefModel> chefs = []; // List to store chefs from Firestore
  ChefModel? selectedChef; // Currently selected chef
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

              return OrderModel(
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
                          return ChefModel(id: doc.id, name: doc['chefName']);
                        } else {
                          // Handle the case where 'chefName' field is missing
                          print(
                              "Warning: 'chefName' field is missing in document ${doc.id}");
                          return ChefModel(id: doc.id, name: 'N/A');
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
                                      ChefModel chef = chefs[chefIndex];
                                      return Container(
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
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

                                              String selectedChefId = chef.id;

                                              List<Map<String, dynamic>>
                                                  assignedOrders =
                                                  orders[chefIndex].items;
                                              await saveAssignedOrders(
                                                  selectedChefId,
                                                  chef.name,
                                                  assignedOrders);

                                              await Future.delayed(
                                                  Duration(seconds: 2));
                                              dialogContext = context;
                                              Navigator.pop(dialogContext);
                                              Navigator.pushReplacement(
                                                dialogContext,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashBoardScreen(),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      "https://c8.alamy.com/comp/2F05NFR/hat-chef-logo-vector-illustration-design-2F05NFR.jpg"),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(chef.name),
                                              ],
                                            ),
                                          ));
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
