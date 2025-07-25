

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/services/user_services.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();


  Future<void> createTask({
    required String title,
    required String description,
    required String assignedToUserId,
    required DateTime dueDate,
    String priority = 'medium',
  }) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }


      final isAdmin = await _userService.isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Only admins can create tasks');
      }

      
      final taskData = {
        'title': title,
        'description': description,
        'assignedTo': assignedToUserId,
        'assignedBy': currentUserId,
        'status': 'pending',
        'priority': priority,
        'dueDate': Timestamp.fromDate(dueDate),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('tasks').add(taskData);
      print('Task created successfully');
      
    } catch (e) {
      print('Error creating task: $e');
      throw e;
    }
  }

 
  Stream<QuerySnapshot> getTasksForCurrentUser() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('tasks')
        .where('assignedTo', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }


  Stream<QuerySnapshot> getAllTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final taskDoc = await _firestore.collection('tasks').doc(taskId).get();
      
      if (!taskDoc.exists) {
        throw Exception('Task not found');
      }

      final taskData = taskDoc.data()!;
      final isAdmin = await _userService.isCurrentUserAdmin();
      
     
      if (!isAdmin && taskData['assignedTo'] != currentUserId) {
        throw Exception('You can only update tasks assigned to you');
      }

     
      await _firestore.collection('tasks').doc(taskId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Task status updated to: $newStatus');
      
    } catch (e) {
      print('Error updating task status: $e');
      throw e;
    }
  }


  Future<void> deleteTask(String taskId) async {
    try {
      final isAdmin = await _userService.isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Only admins can delete tasks');
      }

      await _firestore.collection('tasks').doc(taskId).delete();
      print('Task deleted successfully');
      
    } catch (e) {
      print('Error deleting task: $e');
      throw e;
    }
  }

  
  Stream<QuerySnapshot> getTasksAssignedByCurrentUser() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('tasks')
        .where('assignedBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  
  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
    required String assignedToUserId,
    required DateTime dueDate,
    required String priority,
  }) async {
    try {
      final isAdmin = await _userService.isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Only admins can update task details');
      }

      await _firestore.collection('tasks').doc(taskId).update({
        'title': title,
        'description': description,
        'assignedTo': assignedToUserId,
        'priority': priority,
        'dueDate': Timestamp.fromDate(dueDate),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Task updated successfully');
      
    } catch (e) {
      print('Error updating task: $e');
      throw e;
    }
  }
}