import 'package:farmers_market_swe/auth/FarmerSignUpRequest.dart';
import 'package:farmers_market_swe/auth/farmer_auth_service.dart';
import 'package:farmers_market_swe/components/my_button.dart';
import 'package:farmers_market_swe/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FarmDetailsPage extends StatefulWidget {
  final Map<String, String> userdata;
  const FarmDetailsPage({super.key, required this.userdata});

  @override
  State<FarmDetailsPage> createState() => _FarmDetailsPageState();
}

class _FarmDetailsPageState extends State<FarmDetailsPage> {
  final TextEditingController _phoneNum = TextEditingController();
  final TextEditingController _farmName = TextEditingController();
  final TextEditingController _farmLocationLat = TextEditingController();
  final TextEditingController _farmLocationLon = TextEditingController();
  final TextEditingController _farmSize = TextEditingController();
  final FarmerSignupService signupService = FarmerSignupService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');
  void register() async {
    try{
      final request = FarmerSignupRequest(username: widget.userdata['username']!, email: widget.userdata['email']!, password: widget.userdata['password']!, phoneNumber: _phoneNum.text, farmName: _farmName.text, farmLocationLat: double.parse(_farmLocationLat.text), farmLocationLon: double.parse(_farmLocationLon.text), farmSize: double.parse(_farmSize.text), farmCrops: []);
      final response = await signupService.signUp(request);
      context.go('/login'); //need to create a home page for farmer
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your request has been sent. Wait for the approval")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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
              SizedBox(height: 180,),
              Text("Fill in the Farm details below", style: TextStyle(fontSize: 20),),
              SizedBox(height: 20,),
              MyTextField(controller: _phoneNum, hintText: "Phone Number", obscureText: false),
              SizedBox(height: 10,),
              MyTextField(controller: _farmName, hintText: "Farm Name", obscureText: false),
              SizedBox(height: 10,),
              MyTextField(controller: _farmLocationLat, hintText: "Enter latitude of farm", obscureText: false),
              SizedBox(height: 10,),
              MyTextField(controller: _farmLocationLon, hintText: "Enter longitude", obscureText: false),
              SizedBox(height: 10,),
              MyTextField(controller: _farmSize, hintText: "Farm size", obscureText: false),
              SizedBox(height: 10,),
              MyButton(onTap:() => register(), text: 'Sign up', textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), padding: 25, margin: 25, borderRadius: 8, fillInColor: Colors.black)
        
            ],
          ),
        ),
      ),
    );
  }
}