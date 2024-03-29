import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';

class ChefHomeScreen extends StatefulWidget {
  @override
  _ChefHomeScreenState createState() => _ChefHomeScreenState();
}

class _ChefHomeScreenState extends State<ChefHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: _buildChefItemsList(),
    );
  }

  void _logout(BuildContext context) async {
    await AuthService().signOut(context);
  }

  Widget _buildChefItemsList() {
    return FutureBuilder<String?>(
      future: AuthService().getLoggedInUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? loggedInChefId = snapshot.data;

          if (loggedInChefId == null) {
            // Handle the case where the user is not logged in
            return Center(child: Text('User not logged in.'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('assigned_orders')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<List<String>> assignedItemsList = [];

                // Iterate through the assigned orders and extract items
                for (var doc in snapshot.data!.docs) {
                  List<dynamic> items = doc['orders'];
                  List<String> assignedItems =
                      items.map((item) => item['name'].toString()).toList();
                  assignedItemsList.add(assignedItems);
                }

                if (assignedItemsList.isEmpty) {
                  return Center(
                    child: Text(
                      'No orders Yet',
                      style: textstyle(fontSize: 20),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: assignedItemsList.length,
                  itemBuilder: (context, index) {
                    int orderNumber = index + 1;
                    return OrderCard(
                      orderNumber: orderNumber,
                      assignedItemsList: assignedItemsList,
                      index: index,
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final int index;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.assignedItemsList,
    required this.index,
  });

  final int orderNumber;
  final List<List<String>> assignedItemsList;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kyellow,
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Order #$orderNumber',
            style: textstyle(
                color: Colors.black, fontSize: 22, weight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          ...assignedItemsList[index]
              .map((item) => Text(
                    item,
                    style: textstyle(color: Colors.black),
                  ))
              .toList(),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                "Make this Order Ready?",
                style: textstyle(color: Colors.black, fontSize: 20),
              ),
              SizedBox(
                width: 25,
              ),
              Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                    color: ksecondary, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Yes",
                    style: textstyle(color: kprimary),
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }
}
