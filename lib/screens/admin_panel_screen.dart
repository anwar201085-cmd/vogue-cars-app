import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAdminCard(context, 'Manage Cars', Icons.directions_car, () {}),
          _buildAdminCard(context, 'Financing Requests', Icons.monetization_on, () {}),
          _buildAdminCard(context, 'Insurance Requests', Icons.security, () {}),
          _buildAdminCard(context, 'Warranty Plans', Icons.verified_user, () {}),
          _buildAdminCard(context, 'User Management', Icons.people, () {}),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
