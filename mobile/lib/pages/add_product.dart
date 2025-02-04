import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  bool _isLoading = false;

  Future<void> _uploadImages(int productId) async {
    final url = Uri.parse('https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/product/$productId/images');
    final token = await authService.getToken();
    try {
      final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token';
      for (var image in _images) {
        final file = await http.MultipartFile.fromPath('files', image.path);
        request.files.add(file);
      }
      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Images uploaded successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload images.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while uploading images: $e')));
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images = selectedImages;
      });
    }
  }

  Future<void> _addProduct() async {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('https://farmers-market-35xe.onrender.com/farmer-market-api/farmer/product'); // Replace with your backend URL
      final token = await authService.getToken(); // Retrieve from secure storage or state

      try {
        print(token.toString());
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'name': _nameController.text,
            'category': _categoryController.text,
            'price': double.parse(_priceController.text),
            'quantity': int.parse(_quantityController.text),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product added successfully!')));
          final productId = jsonDecode(response.body)['id'];
          if (_images.isNotEmpty) {
            await _uploadImages(productId);
          }
          Navigator.pop(context); // Return to the previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add product')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Product Name"),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: "Category"),
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text("Upload Images"),
              ),
              _images.isNotEmpty
                  ? Text("${_images.length} images selected")
                  : Text("No images selected"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:() => _addProduct(),
                child: Text("Add Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
