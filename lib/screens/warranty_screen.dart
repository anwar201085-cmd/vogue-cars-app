import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/services/database_service.dart';

class WarrantyScreen extends StatelessWidget {
  const WarrantyScreen({super.key});

  Future<void> _requestInquiry(BuildContext context, String planTitle) async {
    try {
      await DatabaseService().createInquiry({
        'planTitle': planTitle,
        'category': 'Car_Warranty',
      }, 'Warranty_Inquiry');

      final whatsappUrl = "https://wa.me/201098981843?text=استفسار عن خطة الضمان: $planTitle";
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plans = [
      {'title': 'الضمان الأساسي', 'duration': '6 شهور', 'price': '2,500 ج.م', 'features': ['المحرك', 'ناقل الحركة']},
      {'title': 'الضمان القياسي', 'duration': '12 شهر', 'price': '4,500 ج.م', 'features': ['المحرك', 'ناقل الحركة', 'نظام التكييف']},
      {'title': 'الضمان المميز', 'duration': '24 شهر', 'price': '8,000 ج.م', 'features': ['تغطية كاملة', 'خدمة المساعدة على الطريق']},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('خطط ضمان السيارات')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            color: AppColors.surface,
           margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.accent, width: 0.5)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plan['title'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(plan['duration'] as String, style: const TextStyle(color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...(plan['features'] as List<String>).map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [const Icon(Icons.check_circle, size: 16, color: Colors.green), const SizedBox(width: 8), Text(f)]),
                  )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('التكلفة التقديرية', style: TextStyle(fontSize: 10, color: Colors.white54)),
                          Text(plan['price'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => _requestInquiry(context, plan['title'] as String),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                        child: const Text('استفسر الآن'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
