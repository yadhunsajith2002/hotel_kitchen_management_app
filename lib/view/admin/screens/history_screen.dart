// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';
// import 'package:hotel_kitchen_management_app/utils/colors.dart';
// import 'package:open_file/open_file.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({Key? key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   Future<void> generateAndDownloadPDF() async {
//     final pdf = pw.Document();

//     // Load a custom font with Unicode support
//     final fontData = await rootBundle.load('assets/Roboto-Black.ttf');
//     final customFont = pw.Font.ttf(fontData);

//     pdf.addPage(
//       pw.Page(
//         build: (context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             for (var order in orders)
//               pw.Column(
//                 crossAxisAlignment: pw.CrossAxisAlignment.start,
//                 children: [
//                   pw.Text("Order ID: ${order.id}",
//                       style: pw.TextStyle(font: customFont, fontSize: 24)),
//                   for (var item in order['items'])
//                     pw.Text(
//                       "Item: ${item['name']} - \$${item['price']}",
//                       style: pw.TextStyle(font: customFont, fontSize: 24),
//                     ),
//                   pw.Divider(), // Add a divider between orders for better readability
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );

//     final directory = await getDownloadsDirectory();
//     final pdfFile = File("${directory!.path}/data_info.pdf");
//     await pdfFile.writeAsBytes(await pdf.save());

//     // Show a snackbar or any other indication that the PDF is saved
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('PDF downloaded to Downloads folder'),
//       ),
//     );

//     // Open the downloaded file using the default system application
//     OpenFile.open(pdfFile.path);
//   }

//   List<DocumentSnapshot> orders = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () {
//                 generateAndDownloadPDF();
//               },
//               icon: Icon(
//                 Icons.print,
//                 color: kyellow,
//               ))
//         ],
//         title: Text('Order History'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('orders').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             orders = snapshot.data!.docs;

//             return ListView.builder(
//               itemCount: orders.length,
//               itemBuilder: (context, index) {
//                 var order = orders[index];
//                 var orderId = order.id;
//                 var orderItems = order['items'] ?? [];

//                 // Extract item names and prices
//                 List<String> itemDetails = [];
//                 for (var item in orderItems) {
//                   var itemName = item['name'];
//                   var itemPrice = item['price'];
//                   itemDetails.add('$itemName -  \$${itemPrice.toString()}\n');
//                 }

//                 return ListTile(
//                   title: Text('Order ID: $orderId'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(' ${itemDetails.join(' ')}'),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text("Grand Total")
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hotel_kitchen_management_app/utils/colors.dart';
import 'package:hotel_kitchen_management_app/utils/text_styles.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> generateAndDownloadPDF() async {
    final pdf = pw.Document();

    // Load a custom font with Unicode support
    final fontData = await rootBundle.load('assets/Roboto-Black.ttf');
    final customFont = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (var order in orders)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Order ID: ${order.id}",
                      style: pw.TextStyle(font: customFont, fontSize: 24)),
                  for (var item in order['items'])
                    pw.Text(
                      "Item: ${item['name']} - \$${item['price']}",
                      style: pw.TextStyle(font: customFont, fontSize: 24),
                    ),
                  pw.Divider(),
                  // Add a divider between orders for better readability
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Grand Total:",
                          style: pw.TextStyle(font: customFont, fontSize: 24),
                        ),
                        pw.Text("\$${calculateGrandTotal(order['items'])}"),
                      ]),
                  pw.Divider(),
                ],
              ),
          ],
        ),
      ),
    );

    final directory = await getDownloadsDirectory();
    final pdfFile = File("${directory!.path}/data_info.pdf");
    await pdfFile.writeAsBytes(await pdf.save());

    // Show a snackbar or any other indication that the PDF is saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF downloaded to Downloads folder'),
      ),
    );

    // Open the downloaded file using the default system application
    OpenFile.open(pdfFile.path);
  }

  List<DocumentSnapshot> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                generateAndDownloadPDF();
              },
              icon: Icon(
                Icons.print,
                color: kyellow,
              ))
        ],
        title: Text('Order History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            orders = snapshot.data!.docs;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                var order = orders[index];
                var orderId = order.id;
                var orderItems = order['items'] ?? [];

                // Extract item names and prices
                List<String> itemDetails = [];
                for (var item in orderItems) {
                  var itemName = item['name'];
                  var itemPrice = item['price'];
                  itemDetails.add('$itemName -  \$${itemPrice.toString()}\n');
                }

                return Card(
                  color: Colors.grey.shade800,
                  child: ListTile(
                    title: Text(
                      'Order ID: $orderId',
                      style: textstyle(
                          fontSize: 18,
                          color: kprimary,
                          weight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          ' ${itemDetails.join(' ')}',
                          style: textstyle(
                            fontSize: 18,
                            color: kprimary,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Grand Total ",
                              style: textstyle(
                                  fontSize: 22,
                                  color: kprimary,
                                  weight: FontWeight.bold),
                            ),
                            Text(
                              "\$${calculateGrandTotal(order['items'])}",
                              style: textstyle(
                                  fontSize: 22,
                                  color: kprimary,
                                  weight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  double calculateGrandTotal(List<dynamic> items) {
    double grandTotal = 0;
    for (var item in items) {
      grandTotal += item['price'] ?? 0.0;
    }
    return grandTotal;
  }
}
