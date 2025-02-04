import 'dart:convert';

import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> order;

  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');

  OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Colors.green,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: ${order['orderStatus']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Product: ${order['productName']} x ${order['orderedQuantity']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("In warehouse: ${order['warehouseQuantity']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text("Total Price: \$${order['totalPrice']}", style: TextStyle(fontSize: 18)),
            ElevatedButton(onPressed: () => changeOrderStatus(order['id']), child: Text("Mark as DONE"))
          ],
        ),
      ),
    );
  }

  Future<void> changeOrderStatus(int orderId) async {
    final String apiUrl = 'https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/orders/$orderId'; // Replace with your API URL
    final token = await authService.getToken(); // Replace with your token logic

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Order marked as DONE");
      } else if (response.statusCode == 400) {
        final errorMessage = json.decode(response.body);
        print("Error: $errorMessage");
      } else {
        throw Exception("Failed to update order status");
      }
    } catch (e) {
      print("Error: $e");
      print("Error updating order status");
    }
  }
}
