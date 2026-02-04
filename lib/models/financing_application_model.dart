import 'package:cloud_firestore/cloud_firestore.dart';

class FinancingApplication {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String nationalIdFront;
  final String nationalIdBack;
  final String carId;
  final String carBrand;
  final String carModel;
  final String carPrice;
  final String downPayment;
  final String loanAmount;
  final String monthlyInstallment;
  final int loanDuration; // in months
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime? approvedAt;

  FinancingApplication({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.nationalIdFront,
    required this.nationalIdBack,
    required this.carId,
    required this.carBrand,
    required this.carModel,
    required this.carPrice,
    required this.downPayment,
    required this.loanAmount,
    required this.monthlyInstallment,
    required this.loanDuration,
    this.status = 'pending',
    required this.createdAt,
    this.approvedAt,
  });

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'nationalIdFront': nationalIdFront,
      'nationalIdBack': nationalIdBack,
      'carId': carId,
      'carBrand': carBrand,
      'carModel': carModel,
      'carPrice': carPrice,
      'downPayment': downPayment,
      'loanAmount': loanAmount,
      'monthlyInstallment': monthlyInstallment,
      'loanDuration': loanDuration,
      'status': status,
      'createdAt': createdAt,
      'approvedAt': approvedAt,
    };
  }

  /// Create from Firestore document
  factory FinancingApplication.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FinancingApplication(
      id: doc.id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      email: data['email'] ?? '',
      nationalIdFront: data['nationalIdFront'] ?? '',
      nationalIdBack: data['nationalIdBack'] ?? '',
      carId: data['carId'] ?? '',
      carBrand: data['carBrand'] ?? '',
      carModel: data['carModel'] ?? '',
      carPrice: data['carPrice'] ?? '',
      downPayment: data['downPayment'] ?? '',
      loanAmount: data['loanAmount'] ?? '',
      monthlyInstallment: data['monthlyInstallment'] ?? '',
      loanDuration: data['loanDuration'] ?? 0,
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      approvedAt: (data['approvedAt'] as Timestamp?)?.toDate(),
    );
  }
}
