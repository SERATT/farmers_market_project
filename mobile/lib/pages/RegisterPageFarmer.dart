import 'package:farmers_market_swe/components/my_button.dart';
import 'package:farmers_market_swe/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPageFarmer extends StatefulWidget {
  const RegisterPageFarmer({super.key});

  @override
  State<RegisterPageFarmer> createState() => _RegisterPageFarmerState();
}

class _RegisterPageFarmerState extends State<RegisterPageFarmer> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _farmnameController = TextEditingController();
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
        
              Text("Join the Farmers Market to start selling!", style: TextStyle(fontSize: 17),),
              SizedBox(height: 20,),
              MyTextField(controller: _emailController, hintText: "Email", obscureText: false),
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
              MyButton(onTap:() {context.push('/farm_details', extra: {
                'email': _emailController.text,
                'username': _usernameController.text,
                'password': _passwordController.text
              });}, text: "Continue", textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), padding: 25, margin: 25, borderRadius: 8, fillInColor: Colors.black),
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
                  Text("Want to start shopping? "),
                  GestureDetector(
                    onTap: () => context.go('/register_buyer'),
                    child: Text("Join as Buyer", style: TextStyle(fontWeight: FontWeight.bold)),
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