import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/services/database_service.dart';

class ApplyInstallmentScreen extends StatefulWidget {
  final String carId;
  final String carTitle;

  const ApplyInstallmentScreen({super.key, required this.carId, required this.carTitle});

  @override
  State<ApplyInstallmentScreen> createState() => _ApplyInstallmentScreenState();
}

class _ApplyInstallmentScreenState extends State<ApplyInstallmentScreen> {
  File? _idFront;
  File? _idBack;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        if (isFront) _idFront = File(pickedFile.path);
        else _idBack = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitApplication() async {
    if (_idFront == null || _idBack == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all fields and upload ID images')));
      return;
    }

    setState(() => _isUploading = true);
    
    try {
      // Logic to upload images to Firebase Storage and save data to Firestore
      await DatabaseService().createApplication({
        'carId': widget.carId,
        'carTitle': widget.carTitle,
        'userName': _nameController.text,
        'userPhone': _phoneController.text,
        'status': 'Pending',
      });
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Application submitted successfully!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financing Application')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Applying for: ${widget.carTitle}', style: const TextStyle(fontSize: 18, color: AppColors.accent)),
            const SizedBox(height: 24),
            _buildTextField('Full Name', _nameController),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController),
            const SizedBox(height: 32),
            const Text('Upload National ID', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildUploadBox('Front Side', _idFront, () => _pickImage(true))),
                const SizedBox(width: 16),
                Expanded(child: _buildUploadBox('Back Side', _idBack, () => _pickImage(false))),
              ],
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _submitApplication,
                child: _isUploading ? const CircularProgressIndicator() : const Text('Submit Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildUploadBox(String label, File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withOpacity(0.5), style: BorderStyle.solid),
        ),
        child: file == null 
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Icon(Icons.add_a_photo, color: AppColors.accent), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 12))],
            )
          : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(file, fit: BoxFit.cover)),
      ),
    );
  }
}
