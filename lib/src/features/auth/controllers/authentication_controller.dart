import 'package:cpdassignment/src/utils/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  // Firebase auth instance


 


  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  
  // Observable variables for form state
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;

  RxBool isPasswordHidden = true.obs;
  RxBool isConfirmPasswordHidden = true.obs;
  
  // Form validation observables
  final emailError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final confirmPasswordError = Rx<String?>(null);
  final nameError = Rx<String?>(null);
  
  // Storage for remembering login
  final _storage = GetStorage();
  
  @override
  void onInit() {
    super.onInit();
    // Check if there are saved credentials
    final savedEmail = _storage.read('saved_email');
    if (savedEmail != null) {
      emailController.text = savedEmail;
      final savedPassword = _storage.read('saved_password');
      if (savedPassword != null) {
        passwordController.text = savedPassword;
        rememberMe.value = true;
      }
    }
  }
  
  @override
  void onClose() {
    // Dispose all controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  // Toggle remember me option
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }
  
  // Validate email format
  bool validateEmail() {
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      return false;
    }
    emailError.value = null;
    return true;
  }
  
  // Validate password strength
  bool validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      return false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      return false;
    }
    passwordError.value = null;
    return true;
  }
  
  // Validate confirm password match
  bool validateConfirmPassword() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      return false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return false;
    }
    confirmPasswordError.value = null;
    return true;
  }
  
  // Validate name
  bool validateName() {
    if (nameController.text.isEmpty) {
      nameError.value = 'Name is required';
      return false;
    }
    nameError.value = null;
    return true;
  }
  
  // Validate login form
  bool validateLoginForm() {
    final isEmailValid = validateEmail();
    final isPasswordValid = validatePassword();
    return isEmailValid && isPasswordValid;
  }
  
  // Validate registration form
  bool validateRegistrationForm() {
    final isEmailValid = validateEmail();
    final isPasswordValid = validatePassword();
    final isConfirmPasswordValid = validateConfirmPassword();
    final isNameValid = validateName();
    return isEmailValid && isPasswordValid && isConfirmPasswordValid && isNameValid;
  }
  
  // Save credentials if remember me is checked
  void saveCredentials() {
     _storage.write('saved_email', emailController.text);
      _storage.write('saved_password', passwordController.text);
      _storage.write('isLoggedIn', true);

  }
  
  // Login with email and password
Future<bool> login({
  String? email,
  String? password,
}) async {
  if (!validateLoginForm()) return false; // If the form is invalid, return false

  // If email or password is null, fall back to using the text controllers
  if (email == null || password == null) {
    email = emailController.text.trim();
    password = passwordController.text;
  }

  try {
    isLoading.value = true;

    // Perform the sign-in operation
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // If login is successful (user is not null)
    if (user != null) {
      saveCredentials(); // Save credentials if needed
      Get.offAllNamed('/home'); // Navigate to home screen
      return true; // Return true if login is successful
    } else {
      return false; // Return false if user is null
    }
  } on FirebaseAuthException catch (e) {
    // Handle specific Firebase auth errors
    if (e.code == 'user-not-found') {
      Get.snackbar('Error', 'No user found with this email');
    } else if (e.code == 'wrong-password') {
      Get.snackbar('Error', 'Incorrect password');
    } else {
      Get.snackbar('Error', 'Login failed: ${e.message}');
    }
    return false; // Return false on authentication error
  } catch (e) {
    print('Error: $e');
    Get.snackbar('Error', 'An unexpected error occurred');
    return false; // Return false for any other errors
  } finally {
    isLoading.value = false; // Ensure isLoading is set to false in all cases
  }
}

  
  // Register with email and password
  Future<void> register() async {
    if (!validateRegistrationForm()) return;
    
    try {
      isLoading.value = true;
      
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      
      // Update user profile with name
      await userCredential.user?.updateDisplayName(nameController.text.trim());
      
      // Navigate to home screen on successful registration
      Get.offAllNamed('/home');
      
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth errors
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'An account already exists for this email');
      } else {
        Get.snackbar('Error', 'Registration failed: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Password reset
  Future<void> resetPassword() async {
    if (!validateEmail()) return;
    
    try {
      isLoading.value = true;
      
      await _auth.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      
      Get.snackbar(
        'Success', 
        'Password reset link sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', 'Password reset failed: ${e.message}');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred');
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
      Get.snackbar('Error', 'Sign out failed');
    }
  }
  
  // Navigate to registration screen
  void goToRegister() {
    Get.toNamed('/register');
  }
  
  // Navigate to login screen
  void goToLogin() {
    Get.toNamed('/login');
  }
  
  // Navigate to forgot password screen
  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}