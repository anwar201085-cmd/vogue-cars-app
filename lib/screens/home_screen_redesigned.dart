import 'package:flutter/material.dart';
import 'package:vogue_cars/utils/constants.dart';
import 'package:vogue_cars/screens/cars_screen.dart';
import 'package:vogue_cars/screens/warranty_screen.dart';
import 'package:vogue_cars/screens/insurance_screen.dart';
import 'package:vogue_cars/screens/installment_screen_pro.dart';

class HomeScreenRedesigned extends StatefulWidget {
  const HomeScreenRedesigned({super.key});

  @override
  State<HomeScreenRedesigned> createState() => _HomeScreenRedesignedState();
}

class _HomeScreenRedesignedState extends State<HomeScreenRedesigned> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const CarsScreen(),
    const InstallmentScreenPro(),
    const WarrantyScreen(),
    const InsuranceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'السيارات'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'تمويل'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: 'ضمان'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'تأمين'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('أهلاً بك في', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text('Vogue Cars', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Image.asset('assets/images/logo.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.directions_car, color: AppColors.accent)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildBanner(),
          const SizedBox(height: 24),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('خدماتنا المميزة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          _buildServiceGrid(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [AppColors.surface, AppColors.primary]),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800'),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ابحث عن سيارة أحلامك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text('أفضل عروض التمويل والضمان في مصر', style: TextStyle(fontSize: 14, color: AppColors.accent)),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildServiceCard(Icons.calculate, 'حاسبة التمويل', 'احسب قسطك بسهولة'),
        _buildServiceCard(Icons.verified_user, 'خطط الضمان', 'حماية ممتدة لسيارتك'),
        _buildServiceCard(Icons.security, 'تأمين السيارات', 'أفضل عروض التأمين'),
        _buildServiceCard(Icons.support_agent, 'تواصل معنا', 'استشارات مجانية'),
      ],
    );
  }

  Widget _buildServiceCard(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accent, size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 10, color: Colors.white54), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
