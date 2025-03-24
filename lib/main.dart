import 'package:cpdassignment/src/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetStorage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil with design size
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
          // You can define initial routes here
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => HomeScreen(),
            ),
            // Add more routes as needed
          ],
        );
      },
    );
  }
}

// Example Home Screen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StudySpot',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to StudySpot!',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
