import 'package:cpdassignment/src/features/auth/screens/login.dart';
import 'package:cpdassignment/src/features/auth/screens/onboarding.dart';
import 'package:cpdassignment/src/features/auth/screens/register_screen.dart';
import 'package:cpdassignment/src/features/home/screens/add_spot.dart';
import 'package:cpdassignment/src/features/home/screens/details_screens.dart';
import 'package:cpdassignment/src/features/home/screens/favourite_screen.dart';
import 'package:cpdassignment/src/features/home/screens/homepage.dart';
import 'package:cpdassignment/src/features/home/screens/profile_screen.dart';
import 'package:cpdassignment/src/features/home/screens/search_screen.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppRoutes {
  static final box = GetStorage(); // Initialize GetStorage

  static final routes = [
    GetPage(
      name: '/',
      page: () => Onboarding(),
    ),
    GetPage(
      name: '/login',
      page: () => LoginScreen(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => HomeScreen(),
    ),
    GetPage(
      name: '/spot-details',
      page: () => SpotDetailsScreen(),
    ),
    GetPage(
      name: '/add-spot',
      page: () => AddSpotScreen(),
    ),
    GetPage(
      name: '/profile',
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: '/favorites',
      page: () => FavoritesScreen(),
    ),
    GetPage(
      name: '/search',
      page: () => SearchScreen(),
    ),
  ];

  // Determine the initial route dynamically
  static String get initial {
    bool? isFirstTime = box.read('onboarding_completed');
    bool? isLoggedIn = box.read('isLoggedIn');

    if (isFirstTime == null) {
      box.write('onboarding_completed', true);
      return '/';
    } else if (isFirstTime == false && (isLoggedIn == null || isLoggedIn == false)) {
      return '/home';
    } else {
      return '/home';
    }
  }
}
