import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vogue_cars/models/car_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection name updated to comply with Lead Generation model
  final String _inquiryCollection = 'customer_inquiries';

  // Get Cars
  Stream<List<Car>> getCars() {
    return _db.collection('cars').where('isActive', isEqualTo: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Car.fromFirestore(doc.data(), doc.id)).toList(),
        );
  }

  // Create Inquiry (formerly Application)
  Future<void> createInquiry(Map<String, dynamic> data, String requestType) async {
    try {
      await _db.collection(_inquiryCollection).add({
        ...data,
        'requestType': requestType,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating inquiry: $e');
      rethrow;
    }
  }

  // Legacy support for existing code
  Future<void> createApplication(Map<String, dynamic> appData) async {
    await createInquiry(appData, 'General_Inquiry');
  }
}
