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


class AppRoutes {
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
    // GetPage(
    //   name: '/history',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual History screen
    // ),
    // GetPage(
    //   name: '/reviews',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual Reviews screen
    // ),
    // GetPage(
    //   name: '/my-spots',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual My Spots screen
    // ),
    // GetPage(
    //   name: '/notifications',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual Notifications screen
    // ),
    // GetPage(
    //   name: '/privacy',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual Privacy screen
    // ),
    // GetPage(
    //   name: '/help',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual Help screen
    // ),
    // GetPage(
    //   name: '/about',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual About screen
    // ),
    // GetPage(
    //   name: '/forgot-password',
    //   page: () => FavoritesScreen(), // Placeholder - would be actual Forgot Password screen
    // ),
  ];
  
  // Initial route
  static String get initial => '/';
  
  // Route guards
  static void configureRoutes() {
    // Add route middleware here if needed
    // For example, authentication checks
  }
}