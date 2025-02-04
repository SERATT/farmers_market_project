import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:farmers_market_swe/models/OrderRequestDto.dart';
import 'package:farmers_market_swe/pages/product_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePageBuyer extends StatefulWidget {
  const HomePageBuyer({super.key});

  @override
  State<HomePageBuyer> createState() => _HomePageBuyerState();
}

class _HomePageBuyerState extends State<HomePageBuyer> {
  final AuthService authService = AuthService(
      baseUrl:
          'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');
  List<Map<String, dynamic>> _products = [];

  String _searchQuery = "";
  String _selectedCategory = "All";
  String _selectedSort = "Popularity";
  bool _isLoading = false;

  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the page loads
  }

  Future<void> _fetchProducts() async {
    final url = Uri.parse(
        'https://farmers-market-35xe.onrender.com/farmer-market-api/buyer/product?page=0&size=20'); // Replace with actual API endpoint
    final token = await authService.getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract products from the "content" field
        setState(() {
          _products = (data['content'] as List).map((item) {
            return {
              "id": item["id"],
              "name": item["name"],
              "category": item["category"],
              "price": item["price"],
              "quantity": item["quantity"],
              "imageIds": item["imageIds"]
              //"location": "Unknown", // Replace with farm location if available
              //"images": ["https://via.placeholder.com/150"], // Replace if backend includes image URLs
              //"popularity": 0, // Replace with popularity data if available
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $e')),
      );
    }
  }

  void _showProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }

  void _logout() async {
    await authService.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer Home"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(onPressed: () => _logout(), icon: Icon(Icons.logout)),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          _buildSortOptions(),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return GestureDetector(
                    onTap: () => _showProductDetails(product),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text("Price: \$${product['price']}"),
                            Text("In stock: ${product['quantity']}"),
                            SizedBox(height: 20),
                            // Order button
                            ElevatedButton(
                              onPressed: () {
                                _showOrderModal(context, product['id']);
                              },
                              child: Text("Order"),
                            ),
                          ],
                        )));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectedCategory,
        items: ["All", "Vegetables", "Fruits", "Seeds"]
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
        isExpanded: true,
        hint: Text("Filter by Category"),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: _selectedSort,
        items: ["Popularity", "Price (Low to High)", "Price (High to Low)"]
            .map((sortOption) => DropdownMenuItem(
                  value: sortOption,
                  child: Text(sortOption),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedSort = value!;
          });
        },
        isExpanded: true,
        hint: Text("Sort by"),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Search"),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(hintText: "Search for products"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            )
          ],
        );
      },
    );
  }

  // Show the modal for order input
  void _showOrderModal(BuildContext context, int productId) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Order Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  int quantity = int.tryParse(quantityController.text) ?? 0;
                  double price = double.tryParse(priceController.text) ?? 0.0;

                  if (quantity > 0 && price > 0) {
                    bool ordered = await _order_product(productId, quantity, price);
                    if (ordered) {
                      print(
                          'Ordered $quantity units of product $productId at price \$${price}');
                    }
                    Navigator.pop(context); // Close the modal
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Please enter valid quantity and price')),
                    );
                  }
                },
                child: Text('Confirm Order'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _order_product(int productId, int quantity, double price) async {
    final token = await authService.getToken();
    final url = Uri.parse("https://farmers-market-35xe.onrender.com/farmer-market-api/buyer/order");
    var request = OrderRequestDto(productId: productId, quantity: quantity, totalPrice: price);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
