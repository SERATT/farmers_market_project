import 'package:farmers_market_swe/auth/BuyerSignUpRequest.dart';
import 'package:farmers_market_swe/auth/buyer_auth_service.dart';
import 'package:farmers_market_swe/components/my_button.dart';
import 'package:farmers_market_swe/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<String> _selectedDeliveryMethods = [];
  String? _currentSelectedMethod;
  final BuyerSignupService signupService = BuyerSignupService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');

  void _register() async {
      try {
        
        final request = BuyerSignupRequest(username: _usernameController.text, email: _emailController.text, password: _passwordController.text, name: _nameController.text, preferredDeliveryMethods: _selectedDeliveryMethods);

        final response  = await signupService.signUp(request);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response)), // Success message
        );
        context.go('/buyer');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
      backgroundColor: const Color.fromARGB(255, 193, 199, 185),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 110,),
        
              Icon(Icons.lock, size: 100,),
        
              SizedBox(height: 60,),
        
              Text("Join the Farmers Market to start shopping!", style: TextStyle(fontSize: 17),),
              SizedBox(height: 20,),
              MyTextField(controller: _nameController, hintText: "Name", obscureText: false),
              SizedBox(height: 10,),
              MyTextField(controller: _emailController, hintText: "Email", obscureText: false),
              SizedBox(height: 20,),
              MyTextField(controller: _usernameController, hintText: "Username", obscureText: false),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField<String>(
                    value: _currentSelectedMethod,
                    hint: Text('Select Delivery Method'),
                    items: [
                      'MAIL_TO_POST',
                      'MAIL_TO_DOOR',
                      'IN_PERSON',
                    ].map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value!=null && !_selectedDeliveryMethods.contains(value)) {
                        setState(() {
                          _currentSelectedMethod = value;
                          _selectedDeliveryMethods.add(value!);
                        });
                      }
                    },
                  ),
              ),
                SizedBox(height: 10),
                Wrap(
                  children: _selectedDeliveryMethods.map((method) {
                    return Chip(
                      label: Text(method),
                      onDeleted: () {
                        setState(() {
                          _selectedDeliveryMethods.remove(method);
                        });
                      },
                    );
                  }).toList(),
                ),
              SizedBox(height: 10,),
              MyTextField(controller: _passwordController, hintText: "Password", obscureText: true),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
        
                    GestureDetector( onTap:(){
                      context.go('/reset_password');//go to reset page
                    },
                    child:  Text("Forgot password?",  style: TextStyle(),)),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              MyButton(onTap:() => _register(), text: "Sign Up", textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), padding: 25, margin: 25, borderRadius: 8, fillInColor: Colors.black),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", ),
                  GestureDetector(
                    onTap: (){
                      context.go('/login');//go to register page
                    },
                    child: 
                      Text("Sign in!", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Want to start selling? "),
                  GestureDetector(
                    onTap: () => context.go('/register_farmer'),
                    child: Text("Join as Farmer", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              )
              
              
        
            ],
          ),
        ),
      )
    );
  }
}
