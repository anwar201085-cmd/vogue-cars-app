import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vogue_cars/utils/constants.dart';

class InstallmentScreenPro extends StatefulWidget {
  const InstallmentScreenPro({super.key});

  @override
  State<InstallmentScreenPro> createState() => _InstallmentScreenProState();
}

class _InstallmentScreenProState extends State<InstallmentScreenPro> {
  final _priceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  double _years = 3;
  double _interestRate = 16.5; 
  double _monthlyInstallment = 0;
  double _estimatedTotal = 0;
  double _totalInterest = 0;

  void _calculate() {
    double price = double.tryParse(_priceController.text) ?? 0;
    double downPayment = double.tryParse(_downPaymentController.text) ?? 0;

    if (price > 0 && downPayment < price && downPayment >= 0) {
      double downPaymentPercent = downPayment / price;
      _interestRate = AppConfig.getInterestRate(downPaymentPercent) * 100;

      final principal = price - downPayment;
      final n = _years.toInt() * 12;
      final monthlyRate = _interestRate / 100 / 12;

      if (monthlyRate == 0) {
        _monthlyInstallment = principal / n;
        _estimatedTotal = _monthlyInstallment * n;
        _totalInterest = 0;
      } else {
        _monthlyInstallment = (principal * monthlyRate * pow(1 + monthlyRate, n)) / (pow(1 + monthlyRate, n) - 1);
        _estimatedTotal = _monthlyInstallment * n;
        _totalInterest = _estimatedTotal - principal;
      }
    } else {
      _monthlyInstallment = 0;
      _estimatedTotal = 0;
      _totalInterest = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حاسبة التمويل')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('احسب قسطك التقديري', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('أدخل تفاصيل السيارة للحصول على عرض تمويل تقديري', style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('بيانات السيارة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildTextField('سعر السيارة (ج.م)', _priceController, Icons.directions_car),
                  const SizedBox(height: 12),
                  _buildTextField('المقدم (ج.م)', _downPaymentController, Icons.payments),
                  const SizedBox(height: 20),
                  const Text('شروط التمويل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildSliderRow('مدة التمويل', _years, 1, 7, (value) {
                    setState(() => _years = value);
                    _calculate();
                  }),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('نسبة الفائدة السنوية', style: TextStyle(fontSize: 14)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Text('${_interestRate.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_monthlyInstallment > 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.accent.withOpacity(0.1), AppColors.accent.withOpacity(0.05)]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    _buildResultRow('القسط الشهري التقديري', '${_monthlyInstallment.toStringAsFixed(0)} ج.م', AppColors.accent),
                    const SizedBox(height: 12),
                    _buildResultRow('إجمالي التكلفة التقديرية', '${_estimatedTotal.toStringAsFixed(0)} ج.م', Colors.white),
                    const SizedBox(height: 12),
                    _buildResultRow('إجمالي الفوائد', '${_totalInterest.toStringAsFixed(0)} ج.م', Colors.orange),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: const Text('احسب الآن'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.accent),
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (_) => _calculate(),
    );
  }

  Widget _buildSliderRow(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text('${value.toInt()} سنوات', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(value: value, min: min, max: max, divisions: (max - min).toInt(), activeColor: AppColors.accent, onChanged: onChanged),
      ],
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _downPaymentController.dispose();
    super.dispose();
  }
}
