import 'package:cpdassignment/src/utils/app_routes.dart';
import 'package:cpdassignment/src/utils/app_theme.dart';
import 'package:cpdassignment/src/utils/auth_service.dart';
import 'package:cpdassignment/src/utils/dependencies_injection.dart';
import 'package:cpdassignment/src/utils/notofication_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize dependencies
  await DependencyInjection.init();
  



    final notificationService = NotificationService();
  await notificationService.initNotifications();
  
  // Register with GetX
  Get.put(notificationService);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.put(AuthService());
    
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'StudySpot',
          theme: AppTheme.getTheme(),
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          initialRoute: AppRoutes.initial,
          getPages: AppRoutes.routes,
          
          // Check if user is logged in and handle initial route
          home: Obx(() => authService.isLoggedIn.value 
              ? const SplashScreen()
              : Container()
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }
  
  // Check if this is the first time running the app
  Future<void> _checkFirstRun() async {
    final storage = GetStorage();
    final hasCompletedOnboarding = storage.read<bool>('onboarding_completed') ?? false;
    
    Future.delayed(const Duration(seconds: 2), () {
      if (hasCompletedOnboarding) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or icon
            Icon(
              Icons.school,
              size: 100.sp,
              color: Colors.white,
            ),
            SizedBox(height: 24.h),
            Text(
              'StudySpot',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}