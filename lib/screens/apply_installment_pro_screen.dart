import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/services/database_service.dart';

class ApplyInstallmentProScreen extends StatefulWidget {
  final String carId;
  final String carTitle;

  const ApplyInstallmentProScreen({
    super.key,
    required this.carId,
    required this.carTitle,
  });

  @override
  State<ApplyInstallmentProScreen> createState() => _ApplyInstallmentProScreenState();
}

class _ApplyInstallmentProScreenState extends State<ApplyInstallmentProScreen> {
  File? _idFront;
  File? _idBack;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage(bool isFront) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _idFront = File(pickedFile.path);
        } else {
          _idBack = File(pickedFile.path);
        }
      });
    }
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      _showError('يرجى إدخال الاسم بالكامل');
      return false;
    }
    if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
      _showError('يرجى إدخال رقم هاتف صحيح');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _submitInquiry() async {
    if (!_validateInputs()) return;

    setState(() => _isUploading = true);

    try {
      await DatabaseService().createInquiry({
        'carId': widget.carId,
        'carTitle': widget.carTitle,
        'userName': _nameController.text,
        'userPhone': _phoneController.text,
        'userEmail': _emailController.text,
        'hasIdUploaded': _idFront != null && _idBack != null,
      }, 'Financing_Inquiry');

      if (mounted) {
        final whatsappUrl = "https://wa.me/201098981843?text=استفسار عن تمويل سيارة: ${widget.carTitle}\nالاسم: ${_nameController.text}\nالهاتف: ${_phoneController.text}";
        if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
          await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إرسال طلبك بنجاح، سيتم التواصل معك عبر واتساب'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      _showError('حدث خطأ: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب استفسار تمويل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('السيارة المختارة', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(widget.carTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('المعلومات الشخصية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField('الاسم بالكامل', _nameController, Icons.person),
            const SizedBox(height: 12),
            _buildTextField('رقم الهاتف', _phoneController, Icons.phone),
            const SizedBox(height: 12),
            _buildTextField('البريد الإلكتروني (اختياري)', _emailController, Icons.email),
            const SizedBox(height: 24),
            const Text('رفع صورة البطاقة (اختياري)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('يمكنك رفع الصور الآن لتسريع الإجراءات أو تخطي هذه الخطوة', style: TextStyle(fontSize: 12, color: Colors.white54)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildUploadBox('وجه البطاقة', _idFront, () => _pickImage(true))),
                const SizedBox(width: 12),
                Expanded(child: _buildUploadBox('ظهر البطاقة', _idBack, () => _pickImage(false))),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploading ? null : _submitInquiry,
                icon: _isUploading ? const CircularProgressIndicator() : const Icon(Icons.send),
                label: const Text('إرسال الطلب والتواصل عبر واتساب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accent),
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
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: file == null
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.camera_alt, color: AppColors.accent), Text(label, style: const TextStyle(fontSize: 12))])
            : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(file, fit: BoxFit.cover)),
      ),
    );
  }
}
