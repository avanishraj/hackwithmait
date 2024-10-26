import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Method to find user document by email and update the entire document
  Future<void> updateUserInfoByEmail(String email, Map<String, dynamic> updatedInfo) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique, we take the first match
        String docId = querySnapshot.docs.first.id;
        await _usersCollection.doc(docId).update(updatedInfo);
        print("User info updated successfully");
      } else {
        print("No user found with the given email");
      }
    } catch (e) {
      print("Failed to update user info: $e");
    }
  }

  // Method to update a specific field by email
  Future<void> updateUserFieldByEmail(String email, String fieldName, dynamic value) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs.first.id;
        await _usersCollection.doc(docId).update({fieldName: value});
        print("$fieldName updated successfully");
      } else {
        print("No user found with the given email");
      }
    } catch (e) {
      print("Failed to update $fieldName: $e");
    }
  }

  // Method to fetch user info by email
  Future<Map<String, dynamic>?> fetchUserInfoByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>?;
      } else {
        print("No user found with the given email");
        return null;
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
      return null;
    }
  }
}
