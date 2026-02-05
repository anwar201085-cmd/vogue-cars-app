import 'package:flutter/material.dart';
import 'package:vogue_cars/models/car_model.dart';
import 'package:vogue_cars/services/database_service.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/screens/apply_installment_pro_screen.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  String _selectedCondition = 'الكل';
  String _selectedBrand = 'الكل';

  final List<String> _brands = ['الكل', 'Toyota', 'BMW', 'Mercedes', 'Skoda', 'Hyundai', 'Kia'];
  final List<String> _conditions = ['الكل', 'جديد', 'مستعمل', 'كهرباء'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('معرض السيارات')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: AppColors.surface,
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: _conditions.map((condition) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(condition),
                          selected: _selectedCondition == condition,
                          onSelected: (selected) => setState(() => _selectedCondition = condition),
                          selectedColor: AppColors.accent,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _brands.length,
                    itemBuilder: (context, index) {
                      final brand = _brands[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(brand),
                          backgroundColor: _selectedBrand == brand ? AppColors.accent : AppColors.primary,
                          onPressed: () => setState(() => _selectedBrand = brand),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Car>>(
              stream: DatabaseService().getCars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.accent));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد سيارات متاحة حالياً'));
                }

                var cars = snapshot.data!;
                // Filter logic would go here based on Arabic labels or underlying model values
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cars.length,
                  itemBuilder: (context, index) => _buildCarCard(cars[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: car.images.isNotEmpty 
                  ? Image.network(car.images[0], height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Container(height: 200, color: Colors.grey[800], child: const Icon(Icons.image, size: 50)),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: car.condition == 'New' ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(car.condition == 'New' ? 'جديد' : 'مستعمل', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(car.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${car.brand} | ${car.year}', style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('السعر التقديري', style: TextStyle(fontSize: 10, color: Colors.white54)),
                        Text('${car.price.toStringAsFixed(0)} ج.م', style: const TextStyle(color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplyInstallmentProScreen(
                              carId: car.id,
                              carTitle: car.title,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                      child: const Text('استفسر الآن'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
