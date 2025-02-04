import 'package:farmers_market_swe/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageFarmer extends StatefulWidget {
  const HomePageFarmer({super.key});

  @override
  State<HomePageFarmer> createState() => _HomePageFarmerState();
}

class _HomePageFarmerState extends State<HomePageFarmer> {
  final AuthService authService = AuthService(baseUrl: 'https://farmers-market-35xe.onrender.com/farmer-market-api/auth');
  void _logout() async {
    await authService.logout();
    context.go('/login');
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Dashboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDashboardTile(
              icon: Icons.add_box,
              title: "Add Products",
              onTap: () => context.push('/add_product'),
            ),
            _buildDashboardTile(
              icon: Icons.inventory,
              title: "Manage Inventory",
              onTap: () => context.push('/manage_inventory'),
            ),
            _buildDashboardTile(
              icon: Icons.attach_money,
              title: "Track Sales",
              onTap: () => context.push('/track_sales'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.green),
        title: Text(title, style: TextStyle(fontSize: 18)),
        onTap: onTap,
      ),
    );
  }
}