import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();
  
  // Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = GetStorage();
  
  // Observable variables
  RxBool isLoggedIn = false.obs;
  final currentUser = Rxn<User>();
  
  @override
  void onInit() {
    super.onInit();
    // Set up auth state listener
    _auth.authStateChanges().listen(_authStateChanged);
  }
  
  // Listen to auth state changes
  void _authStateChanged(User? user) {
    currentUser.value = user;
    isLoggedIn.value = user != null;
  }
  
  // Get current user ID
  String? get currentUserId => currentUser.value?.uid;
  
  // Get current user display name
  String get currentUserName => currentUser.value?.displayName ?? 'StudySpot User';
  
  // Get current user email
  String get currentUserEmail => currentUser.value?.email ?? '';
  
  // Get current user profile image
  String get currentUserPhotoUrl => currentUser.value?.photoURL ?? '';
  
  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }
  
  // Create user with email and password
  Future<User?> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update the user's profile with their name
      await userCredential.user?.updateDisplayName(name);
      
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      
      // Clear remembered credentials
      _storage.remove('saved_email');
      _storage.remove('saved_password');
    } catch (e) {
      rethrow;
    }
  }
  
  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
  
  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Update email
  Future<void> updateEmail(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Update password
  Future<void> updatePassword(String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Delete user
  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
  
  // Initialize service
  Future<AuthService> init() async {
    return this;
  }
}