import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:farmers_market_swe/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ManageInventoryPage extends StatefulWidget {
  @override
  _ManageInventoryPageState createState() => _ManageInventoryPageState();
}

class _ManageInventoryPageState extends State<ManageInventoryPage> {
  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');

  List<Map<String, dynamic>> _products = [];
  void initState() {
    super.initState();
    print("Initializing...");
     _fetchProducts(); // Ensure this is called
  }

  bool _isLoading = false;
Future<void> _fetchProducts() async {
  print("Fetching products...");
  final token = await authService.getToken();
  try {
    final url = Uri.parse('https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/product');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Decode as a Map
      final products = data['content']; // Access the list of products

      if (products is List) {
        setState(() {
          _products = products.map((item) {
            return {
              "id": item["id"],
              "name": item["name"],
              "category": item["category"],
              "quantity": item["quantity"],
              "price": item["price"],
            };
          }).toList();
          _isLoading = false;
        });
        print("Products loaded successfully.");
      } else {
        throw Exception('Unexpected data format: "content" is not a list.');
      }
    } else {
      throw Exception('Failed to load products. Status: ${response.statusCode}');
    }
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    print("Error fetching products: $e");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error fetching products: $e')));
  }
}

void _markAsOutOfStock(int index) async {
  final product = _products[index];
  print(product.toString());

  if (product['quantity'] > 0) {
    final updatedQuantity = product['quantity'] - 1;

    try {
      final token = await authService.getToken();
      final url = Uri.parse(
        'https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/product/${product['id']}',
      );
      print(url.toString());

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": product['id'],
          "name": product['name'],
          "category": product['category'],
          "price": product['price'],
          "quantity": updatedQuantity,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _products[index]['quantity'] = updatedQuantity;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product quantity updated successfully.')),
        );
      } else {
        throw Exception('Failed to update product quantity.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating product quantity: $e')),
      );
      print(e.toString());
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Product is already out of stock.')),
    );
  }
}


void _deleteProduct(int index) async {
  final product = _products[index];

  try {
    final token = await authService.getToken();
    final url = Uri.parse(
      'https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/product/${product['id']}',
    );

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _products.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully.')),
      );
    } else {
      throw Exception('Failed to delete product.');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting product: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Inventory")),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            onTap: () => _showProductDetails(product),
            title: Text(product['name']),
            subtitle: Text("Quantity: ${product['quantity']} Price: \$${product['price']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _markAsOutOfStock(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () => _deleteProduct(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }
}
