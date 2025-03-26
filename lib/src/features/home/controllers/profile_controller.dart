import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileController extends GetxController {
  // Firebase instances
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _imagePicker = ImagePicker();
  
  // Observable variables
  final isLoading = false.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final profileImageUrl = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }
  
  // Load user data from Firebase
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      
      // Get current user
      final user = _auth.currentUser;
      
      if (user != null) {
        userName.value = user.displayName ?? 'StudySpot User';
        userEmail.value = user.email ?? '';
        profileImageUrl.value = user.photoURL ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 208, 107, 99),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Edit profile
  void editProfile() async {
    final nameController = TextEditingController(text: userName.value);
    
    Get.dialog(
      AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile image edit
            GestureDetector(
              onTap: _pickProfileImage,
              child: Obx(() => CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage: profileImageUrl.value.isNotEmpty
                  ? NetworkImage(profileImageUrl.value)
                  : null,
                child: profileImageUrl.value.isEmpty
                  ? Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: Colors.grey[600],
                    )
                  : null,
              )),
            ),
            SizedBox(height: 16),
            
            // Name field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateProfile(nameController.text);
              Get.back();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
  
  // Pick profile image
  Future<void> _pickProfileImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _uploadProfileImage(file);
    }
  }
  
  // Upload profile image to Firebase Storage
  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      isLoading.value = true;
      
      final user = _auth.currentUser;
      if (user == null) return;
      
      final fileName = 'profile_${user.uid}.jpg';
      final reference = _storage.ref().child('profile_images/$fileName');
      final uploadTask = reference.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Update user profile
      await user.updatePhotoURL(downloadUrl);
      profileImageUrl.value = downloadUrl;
      
      Get.snackbar(
        'Success',
        'Profile image updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error uploading profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Update profile information
  Future<void> _updateProfile(String name) async {
    try {
      isLoading.value = true;
      
      final user = _auth.currentUser;
      if (user == null) return;
      
      // Update display name if changed
      if (name != userName.value) {
        await user.updateDisplayName(name);
        userName.value = name;
      }
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Delete account
  Future<void> deleteAccount() async {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _confirmDeleteAccount,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  // Confirm account deletion
  Future<void> _confirmDeleteAccount() async {
    try {
      isLoading.value = true;
      Get.back(); // Close the confirmation dialog
      
      // Get current user
      final user = _auth.currentUser;
      if (user == null) return;
      
      // Delete user profile image from storage if exists
      if (profileImageUrl.value.isNotEmpty) {
        try {
          final fileName = 'profile_${user.uid}.jpg';
          final reference = _storage.ref().child('profile_images/$fileName');
          await reference.delete();
        } catch (e) {
          print('Error deleting profile image: $e');
          // Continue with account deletion even if image deletion fails
        }
      }
      
      // Delete user account
      await user.delete();
      
      Get.snackbar(
        'Account Deleted',
        'Your account has been successfully deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error deleting account: $e');
      
      // Handle Firebase errors specifically
      if (e is FirebaseAuthException) {
        if (e.code == 'requires-recent-login') {
          Get.snackbar(
            'Authentication Required',
            'Please sign in again before deleting your account',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          // Sign out and redirect to login
          await _auth.signOut();
          Get.offAllNamed('/login');
          return;
        }
      }
      
      Get.snackbar(
        'Error',
        'Failed to delete account: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Navigation functions
  void navigateToFavorites() {
    Get.toNamed('/favorites');
  }
  
  void navigateToHistory() {
    Get.toNamed('/history');
  }
  
  void navigateToReviews() {
    Get.toNamed('/reviews');
  }
  
  void navigateToMySpots() {
    Get.toNamed('/my-spots');
  }
  
  void navigateToNotifications() {
    Get.toNamed('/notifications');
  }
  
  void navigateToPrivacy() {
    Get.toNamed('/privacy');
  }
  
  void navigateToHelp() {
    Get.toNamed('/help');
  }
  
  void navigateToAbout() {
    Get.toNamed('/about');
  }
}