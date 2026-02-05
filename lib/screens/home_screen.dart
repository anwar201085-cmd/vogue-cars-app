import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'cars_screen.dart';
import 'home_marketplace_screen.dart';
import 'installment_screen_pro.dart';
import 'ev_warranty_pro_screen.dart';
import 'insurance_screen.dart';
import 'order_tracking_screen.dart';
import 'admin_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeMarketplaceScreen(),
    const CarsScreen(),
    const InstallmentScreenPro(),
    const EVWarrantyProScreen(),
    const InsuranceScreen(),
    const OrderTrackingScreen(),
    const AdminPanelScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Cars'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Finance'),
          BottomNavigationBarItem(icon: Icon(Icons.battery_charging_full), label: 'EV'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Insurance'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
        ],
      ),
    );
  }
}
