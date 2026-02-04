import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/services/database_service.dart';

class EVWarrantyProScreen extends StatefulWidget {
  const EVWarrantyProScreen({super.key});

  @override
  State<EVWarrantyProScreen> createState() => _EVWarrantyProScreenState();
}

class _EVWarrantyProScreenState extends State<EVWarrantyProScreen> {
  String _selectedPlan = 'المميز';

  final List<Map<String, dynamic>> _warrantyPlans = [
    {
      'name': 'الأساسي',
      'price': 2500,
      'duration': '3 سنوات',
      'color': Colors.blue,
      'features': ['تغطية البطارية (50%)', 'المحرك وناقل الحركة', 'الأنظمة الكهربائية', 'دعم أساسي'],
      'description': 'حماية أساسية لسيارتك الكهربائية',
    },
    {
      'name': 'المميز',
      'price': 5000,
      'duration': '5 سنوات',
      'color': AppColors.accent,
      'features': ['تغطية البطارية (100%)', 'المحرك وناقل الحركة', 'الأنظمة الكهربائية', 'نظام الشحن', 'دعم ذو أولوية', 'فحص مجاني'],
      'description': 'راحة بال كاملة',
      'popular': true,
    },
    {
      'name': 'النخبة',
      'price': 8500,
      'duration': '7 سنوات',
      'color': Colors.amber,
      'features': ['تغطية البطارية (100%)', 'المحرك وناقل الحركة', 'الأنظمة الكهربائية', 'نظام الشحن', 'التعليق والفرامل', 'دعم 24/7', 'فحص مجاني', 'مساعدة على الطريق', 'ضمان استبدال البطارية'],
      'description': 'أقصى حماية ومزايا',
    },
  ];

  Future<void> _requestInquiry(String planName) async {
    try {
      await DatabaseService().createInquiry({
        'planName': planName,
        'category': 'EV_Warranty',
      }, 'EV_Warranty_Inquiry');

      final whatsappUrl = "https://wa.me/201098981843?text=استفسار عن ضمان سيارة كهربائية: $planName";
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
      appBar: AppBar(title: const Text('ضمان السيارات الكهربائية')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              color: AppColors.primary,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('خطط ضمان EV', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('حماية شاملة لسيارتك الكهربائية ومكوناتها الحساسة', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _warrantyPlans.map((plan) {
                  final isSelected = _selectedPlan == plan['name'];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPlan = plan['name']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? plan['color'] : Colors.transparent, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(plan['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text(plan['description'], style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                  ]),
                                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                    Text('${plan['price']} ج.م', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: plan['color'])),
                                    Text(plan['duration'], style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ... (plan['features'] as List<String>).map((f) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(children: [Icon(Icons.check_circle, size: 16, color: plan['color']), const SizedBox(width: 8), Text(f, style: const TextStyle(fontSize: 12))]),
                              )),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _requestInquiry(plan['name']),
                                  style: ElevatedButton.styleFrom(backgroundColor: plan['color']),
                                  child: const Text('استفسر الآن'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
