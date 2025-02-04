import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../auth/auth_service.dart';

class ProductDetailsPage extends StatelessWidget {
  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');
  final Map<String, dynamic> product;
  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child:product['imageIds'] != null && product['imageIds'].isNotEmpty
                  ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product['imageIds'].length,
                itemBuilder: (context, index) {
                  String imageId = product['imageIds'][index].toString();
                  return FutureBuilder<Uint8List>(
                    future: fetchImageResource(imageId), // Fetch image resource
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(child: Text("Error loading image"));
                      } else if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            width: 150,
                          ),
                        );
                      } else {
                        return Center(child: Text("No image data"));
                      }
                    }
                  );
                }
              ) : Center(child: Text("No image data"))
            ),
            SizedBox(height: 20),
            Text("Price: \$${product['price']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Available Quantity: ${product['quantity']}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SizedBox(height: 20),
            Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(product['description'] ?? "No description available"),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> fetchImageResource(String imageId) async {
    // Replace with your backend API URL
    final String apiUrl = 'https://farmers-market-35xe.onrender.com/farmer-market-api/images/$imageId';
    final token = await authService.getToken();
    try {
      final response = await http.get(
          Uri.parse(apiUrl), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        return response.bodyBytes; // Return binary data for the image
      } else {
        throw Exception("Failed to load image resource");
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }

  }
}
