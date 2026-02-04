import 'package:cloud_firestore/cloud_firestore.dart';

class WarrantyPlan {
  final String id;
  final String name;
  final String price;
  final int duration; // in years
  final List<String> features;
  final String description;
  final bool isPopular;

  WarrantyPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
    required this.description,
    this.isPopular = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'duration': duration,
      'features': features,
      'description': description,
      'isPopular': isPopular,
    };
  }

  factory WarrantyPlan.fromJson(Map<String, dynamic> json) {
    return WarrantyPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      duration: json['duration'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      description: json['description'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }
}

class WarrantyPurchase {
  final String id;
  final String userId;
  final String carId;
  final String carBrand;
  final String carModel;
  final String planId;
  final String planName;
  final String planPrice;
  final int planDuration;
  final String purchaseDate;
  final String expiryDate;
  final String status; // active, expired, cancelled
  final DateTime createdAt;

  WarrantyPurchase({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carBrand,
    required this.carModel,
    required this.planId,
    required this.planName,
    required this.planPrice,
    required this.planDuration,
    required this.purchaseDate,
    required this.expiryDate,
    this.status = 'active',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'carId': carId,
      'carBrand': carBrand,
      'carModel': carModel,
      'planId': planId,
      'planName': planName,
      'planPrice': planPrice,
      'planDuration': planDuration,
      'purchaseDate': purchaseDate,
      'expiryDate': expiryDate,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory WarrantyPurchase.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WarrantyPurchase(
      id: doc.id,
      userId: data['userId'] ?? '',
      carId: data['carId'] ?? '',
      carBrand: data['carBrand'] ?? '',
      carModel: data['carModel'] ?? '',
      planId: data['planId'] ?? '',
      planName: data['planName'] ?? '',
      planPrice: data['planPrice'] ?? '',
      planDuration: data['planDuration'] ?? 0,
      purchaseDate: data['purchaseDate'] ?? '',
      expiryDate: data['expiryDate'] ?? '',
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
