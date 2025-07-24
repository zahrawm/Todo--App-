// File: lib/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getCurrentUserRole() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print('No user logged in');
        return null;
      }
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        print('User document does not exist');
        return null;
      }
      
      final userData = userDoc.data();
      return userData?['role'] as String?;
    } catch (e) {
      print('Error getting user role: $e');
      return null;
    }
  }

  Future<bool> isCurrentUserAdmin() async {
    final role = await getCurrentUserRole();
    return role == 'admin';
  }

  
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) return null;
      
      return userDoc.data();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Stream<QuerySnapshot> getEmployees() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .snapshots();
  }

  Future<void> setUserRole(String userId, String role) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('User role set to $role');
    } catch (e) {
      print('Error setting user role: $e');
      throw e;
    }
  }
}