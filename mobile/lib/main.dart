import 'package:farmers_market_swe/pages/FarmDetails.dart';
import 'package:farmers_market_swe/pages/HomePageBuyer.dart';
import 'package:farmers_market_swe/pages/HomePageFarmer.dart';
import 'package:farmers_market_swe/pages/LoginPage.dart';
import 'package:farmers_market_swe/pages/RegisterPage.dart';
import 'package:farmers_market_swe/pages/RegisterPageFarmer.dart';
import 'package:farmers_market_swe/pages/ResetPage.dart';
import 'package:farmers_market_swe/pages/SalesPage.dart';
import 'package:farmers_market_swe/pages/add_product.dart';
import 'package:farmers_market_swe/pages/manage_inventory.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  final GoRouter _goRouter = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login',
      builder: (context, state) => LoginPage(),),
      GoRoute(path: '/register_buyer',
      builder: (context, state) => RegisterPage(),),
      GoRoute(path: '/register_farmer',
      builder: (context, state) => RegisterPageFarmer(),),
      GoRoute(path: '/buyer',
      builder: (context, state) => HomePageBuyer(),), //Home page for buyer
      GoRoute(path: '/farmer',
      builder: (context, state) => HomePageFarmer(),), //Home page for farmer
      GoRoute(path: '/reset_password',
      builder: (context, state) => ResetPage(),),
      GoRoute(path: '/farm_details',
      builder: (context, state) {
        final userdata = state.extra as Map<String, String>;
        return FarmDetailsPage(userdata: userdata,);
      },),
      GoRoute(path: '/add_product', builder:(context, state) => AddProductPage(),),
      GoRoute(path: '/manage_inventory', builder:(context, state) => ManageInventoryPage(),),
      GoRoute(path: '/track_sales', builder: (context, state) => SalesPage(),)
    ]);
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _goRouter, // decides which screen to show
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthCheck extends StatelessWidget {
  bool _isUserLoggedIn() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isUserLoggedIn()) {
      return HomePage(); // If logged in show HomePage
    } else {
      return LoginPage(); // If not logged in show LoginPage
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''), 
      ),
    );
  }
}
