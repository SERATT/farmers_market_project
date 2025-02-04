import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:farmers_market_swe/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'OrderDetailsPage.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<dynamic> orders = [];
  bool isLoading = true;

  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final String apiUrl = 'https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/orders'; // Replace with your backend URL
    final token = await authService.getToken(); // Replace with your auth token logic

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch orders");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order marked as DONE")),
        );
        Navigator.pushReplacementNamed(context, '/track_sales');
      } else if (response.statusCode == 400) {
        final errorMessage = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $errorMessage")),
        );
      } else {
        throw Exception("Failed to update order status");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating order status")),
      );
    }
  }

  void navigateToDetailsPage(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Tracking"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text("Order #${order['productName']}"),
            subtitle: Text("Quantity: ${order['orderedQuantity']}, Price: ${order['totalPrice']}"),
            trailing: order['orderStatus'] == 'PROCESSING'
                ? ElevatedButton(
              onPressed: () =>
                  changeOrderStatus(order['id']),
              child: Text("Mark as DONE"),
            )
                : Text("Completed", style: TextStyle(color: Colors.green)),
            onTap: () => navigateToDetailsPage(order),
          );
        },
      ),
    );
  }
}

