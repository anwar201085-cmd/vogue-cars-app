import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildOrderCard('Financing Request #1234', 'Pending', '2026-01-01'),
          _buildOrderCard('EV Warranty - Premium', 'Active', '2025-12-28'),
          _buildOrderCard('Insurance Policy', 'Approved', '2025-12-25'),
        ],
      ),
    );
  }

  Widget _buildOrderCard(String title, String status, String date) {
    Color statusColor = status == 'Pending' ? Colors.orange : AppColors.accent;
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Date: $date'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: statusColor),
          ),
          child: Text(status, style: TextStyle(color: statusColor, fontSize: 12)),
        ),
      ),
    );
  }
}
