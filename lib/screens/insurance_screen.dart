import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/services/database_service.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  Future<void> _requestCallback(BuildContext context, String planType) async {
    try {
      await DatabaseService().createInquiry({
        'planType': planType,
        'category': 'Car_Insurance',
      }, 'Insurance_Inquiry');

      final whatsappUrl = "https://wa.me/201098981843?text=طلب استفسار عن تأمين سيارة: $planType";
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأمين السيارات')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أمن قيادتك اليوم', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('خطط تأمين شاملة لسيارتك بأفضل الأسعار.', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            _buildInsuranceCard(
              context,
              'تأمين شامل',
              'يغطي الحوادث، السرقة، والحريق.',
              'يبدأ من 3% من قيمة السيارة',
              Colors.teal,
            ),
            const SizedBox(height: 16),
            _buildInsuranceCard(
              context,
              'تأمين ضد الغير',
              'يغطي الأضرار التي تلحق بالمركبات الأخرى.',
              'رسوم سنوية ثابتة',
              Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(BuildContext context, String title, String desc, String price, Color color) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: color, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                  onPressed: () => _requestCallback(context, title),
                  child: const Text('طلب اتصال'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
