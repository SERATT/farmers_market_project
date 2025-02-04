import 'package:farmers_market_swe/auth/AuthRequest.dart';
import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:farmers_market_swe/components/my_button.dart';
import 'package:farmers_market_swe/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');

  void _login() async {
      try {
        final request = AuthRequest(username: _usernameController.text, password: _passwordController.text);
        final response = await authService.login(request);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${response.username}!')),
        );
        print(response.roles);
        // Navigate to the appropriate page based on roles
        if (response.roles.contains('ADMIN')) {
          context.go('/admin_dashboard');
        } else if (response.roles.contains('FARMER')) {
          print("sign in as farmer");
          context.go('/farmer');
        } else {
          context.go('/buyer');
        }
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 110,),
        
              Icon(Icons.lock, size: 100,),
        
              SizedBox(height: 60,),
        
              Text("Welcome back to our Farmers Market", style: TextStyle(fontSize: 17),),
              SizedBox(height: 20,),
              MyTextField(controller: _usernameController, hintText: "Username", obscureText: false),
              SizedBox(height: 20,),
        
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
              MyButton(onTap:() => _login(), text: "Sign In", textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), padding: 25, margin: 25, borderRadius: 8, fillInColor: Colors.black),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New to our community? "),
                  GestureDetector(
                    onTap: (){
                      context.go('/register_buyer');//go to register page
                    },
                    child: 
                      Text("Register!", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              )
              
              
        
            ],
          ),
        ),
      )
    );
  }
}
