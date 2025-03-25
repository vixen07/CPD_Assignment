import 'package:cpdassignment/src/features/auth/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the AuthController instance
    final AuthController controller = Get.put(AuthController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => controller.isLoading.value 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    
            
                    SizedBox(height: 20.h),
                    
                    // Welcome text
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Email field
                    _buildEmailField(controller),
                    
                    SizedBox(height: 20.h),
                    
                    // Password field with toggle visibility
                    _buildPasswordField(controller),
                    
                    SizedBox(height: 16.h),
                    
                    // Remember me and forgot password row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Remember me checkbox
                        Obx(() => Row(
                          children: [
                            SizedBox(
                              height: 24.w,
                              width: 24.w,
                              child: Checkbox(
                                value: controller.rememberMe.value,
                                onChanged: (_) => controller.toggleRememberMe(),
                                activeColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        )),
                        
                        // Forgot password button
                        TextButton(
                          onPressed: controller.goToForgotPassword,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Sign in button
                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Social login options
                    Center(
                      child: Text(
                        'Or sign in with',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton('assets/images/icons8-google-48.png'),
               
                      ],
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Sign up row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                        TextButton(
                          onPressed: controller.goToRegister,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }

// Password field with toggle visibility button
Widget _buildPasswordField(AuthController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label for the password field
      Text(
        'Password',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      SizedBox(height: 8.h),
      
      // Password input field with visibility toggle
      Obx(() => TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        decoration: InputDecoration(
          hintText: 'Enter your password',
          
          // Lock icon at the start of the field
          prefixIcon: Icon(
            Icons.lock_outline, 
            color: Colors.grey[600],
          ),
          
          // Visibility toggle icon at the end of the field
          suffixIcon: IconButton(
            icon: Icon(
              // Change icon based on password visibility state
              controller.isPasswordVisible.value 
                  ? Icons.visibility 
                  : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          
          // Consistent padding for the text field
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          
          // Border styling for different states
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Get.theme.primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red),
          ),
          
          // Display validation error message if there is one
          errorText: controller.passwordError.value,
        ),
        
        // Validate the password whenever it changes
        onChanged: (_) => controller.validatePassword(),
      )),
    ],
  );
}

  // Social login button with icon
Widget _buildSocialButton(String imagePath) {
  return InkWell(
    onTap: () {
      // Implement social login functionality here
      // For example: controller.signInWithGoogle();
    },
    child: Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          height: 30.h,
          width: 30.w,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
  // Email field widget with validation
  Widget _buildEmailField(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[600]),
            contentPadding: EdgeInsets.symmetric(vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Get.theme.primaryColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.red),
            ),
            errorText: controller.emailError.value,
          ),
          onChanged: (_) => controller.validateEmail(),
        ),
      ],
    );
  }}