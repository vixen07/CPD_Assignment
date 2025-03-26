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
  ];
  
  // Initial route
  static String get initial => '/home';
  
  static void configureRoutes() {
  }
}