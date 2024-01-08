import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_kitchen_management_app/Services/auth_services.dart';
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

  // Function to handle logout
  void _logout(BuildContext context) async {
    await AuthService().signOut(context);
    // Navigate to the login screen
  }

  // Function to fetch and display assigned items for the logged-in chef
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
                List<String> assignedItems = [];

                // Iterate through the assigned orders and extract items
                for (var doc in snapshot.data!.docs) {
                  List<dynamic> items = doc['orders'];
                  assignedItems
                      .addAll(items.map((item) => item['name'].toString()));
                }

                if (assignedItems.isEmpty) {
                  return Center(
                      child: Text(
                    'No orders Yet',
                    style: textstyle(fontSize: 20),
                  ));
                }

                return ListView.builder(
                  itemCount: assignedItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(assignedItems[index]),
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
