import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  factory FirebaseService() {
    return _instance;
  }
  
  FirebaseService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // ==================== Authentication ====================
  
  /// Register a new user with email and password
  Future<UserCredential?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Registration error: $e");
      return null;
    }
  }
  
  /// Login user with email and password
  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
  
  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  /// Logout user
  Future<void> logoutUser() async {
    await _auth.signOut();
  }
  
  // ==================== Firestore Database ====================
  
  /// Save user profile data
  Future<void> saveUserProfile(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print("Error saving user profile: $e");
    }
  }
  
  /// Get user profile data
  Future<DocumentSnapshot?> getUserProfile(String userId) async {
    try {
      return await _firestore.collection('users').doc(userId).get();
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }
  
  /// Save financing application
  Future<void> saveFinancingApplication(String userId, Map<String, dynamic> applicationData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('financing_applications')
          .add(applicationData);
    } catch (e) {
      print("Error saving financing application: $e");
    }
  }
  
  /// Get user's financing applications
  Future<List<DocumentSnapshot>> getUserApplications(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('financing_applications')
          .get();
      return snapshot.docs;
    } catch (e) {
      print("Error getting user applications: $e");
      return [];
    }
  }
  
  /// Save warranty purchase
  Future<void> saveWarrantyPurchase(String userId, Map<String, dynamic> warrantyData) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('warranty_purchases')
          .add(warrantyData);
    } catch (e) {
      print("Error saving warranty purchase: $e");
    }
  }
  
  /// Get all cars from Firestore
  Future<List<DocumentSnapshot>> getAllCars() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cars').get();
      return snapshot.docs;
    } catch (e) {
      print("Error getting cars: $e");
      return [];
    }
  }
  
  /// Save a new car listing
  Future<void> saveCar(Map<String, dynamic> carData) async {
    try {
      await _firestore.collection('cars').add(carData);
    } catch (e) {
      print("Error saving car: $e");
    }
  }
  
  // ==================== Firebase Storage ====================
  
  /// Upload image to Firebase Storage
  Future<String?> uploadImage(File imageFile, String userId, String imageName) async {
    try {
      Reference ref = _storage.ref().child('users/$userId/documents/$imageName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
  
  /// Upload multiple documents
  Future<List<String>> uploadDocuments(List<File> files, String userId) async {
    List<String> downloadUrls = [];
    try {
      for (int i = 0; i < files.length; i++) {
        Reference ref = _storage.ref().child('users/$userId/documents/doc_$i');
        UploadTask uploadTask = ref.putFile(files[i]);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      print("Error uploading documents: $e");
      return [];
    }
  }
  
  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String filePath) async {
    try {
      Reference ref = _storage.ref(filePath);
      await ref.delete();
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
  
  // ==================== Real-time Listeners ====================
  
  /// Listen to real-time updates of user profile
  Stream<DocumentSnapshot> getUserProfileStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots();
  }
  
  /// Listen to real-time updates of all cars
  Stream<QuerySnapshot> getCarsStream() {
    return _firestore.collection('cars').snapshots();
  }
  
  /// Listen to user's warranty purchases
  Stream<QuerySnapshot> getUserWarrantiesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('warranty_purchases')
        .snapshots();
  }
}
