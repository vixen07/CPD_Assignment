import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:cpdassignment/src/features/home/service/studyspot_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';


class SearchScreenController extends GetxController {
  // Services
  final _studySpotService = StudySpotService();
  final _location = Location();
  
  // Text controller
  final searchController = TextEditingController();
  
  // Observable variables
  final isLoading = false.obs;
  final allSpots = <StudySpot>[].obs;
  final searchResults = <StudySpot>[].obs;
  final sortBy = 'name'.obs;
  
  // Filter variables
  final hasWifiFilter = false.obs;
  final hasPowerFilter = false.obs;
  final hasCoffeeFilter = false.obs;
  final noiseLevel = ''.obs;
  final minRating = 0.0.obs;
  
  // User location
  final userLatitude = 0.0.obs;
  final userLongitude = 0.0.obs;
  
  // Computed property to check if any filters are active
  bool get hasActiveFilters => 
      hasWifiFilter.value || 
      hasPowerFilter.value || 
      hasCoffeeFilter.value || 
      noiseLevel.value.isNotEmpty || 
      minRating.value > 0;
  
  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
    _loadStudySpots();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;
      
      // Check if location service is enabled
      serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      
      // Check if permission is granted
      permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      
      // Get current location
      final locationData = await _location.getLocation();
      userLatitude.value = locationData.latitude ?? 0.0;
      userLongitude.value = locationData.longitude ?? 0.0;
    } catch (e) {
      print('Error getting location: $e');
    }
  }
  
  // Load all study spots
  Future<void> _loadStudySpots() async {
    try {
      isLoading.value = true;
      final spots = await _studySpotService.getStudySpots();
      allSpots.value = spots;
      searchResults.value = spots;
    } catch (e) {
      print('Error loading study spots: $e');
      Get.snackbar(
        'Error',
        'Failed to load study spots',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Handle search text change
  void onSearchChanged(String query) {
    _filterAndSortSpots();
  }
  
  // Clear search text
  void clearSearch() {
    searchController.clear();
    _filterAndSortSpots();
  }
  
  // Apply filters
  void applyFilters() {
    _filterAndSortSpots();
  }
  
  // Apply sorting
  void applySorting() {
    _sortSpots(searchResults);
  }
  
  // Filter and sort spots based on search text and filters
  void _filterAndSortSpots() {
    isLoading.value = true;
    
    try {
      final query = searchController.text.toLowerCase();
      var results = allSpots.where((spot) {
        // Text search filter
        if (query.isNotEmpty) {
          final nameMatch = spot.name.toLowerCase().contains(query);
          final addressMatch = spot.address.toLowerCase().contains(query);
          if (!nameMatch && !addressMatch) return false;
        }
        
        // Amenity filters
        if (hasWifiFilter.value && !spot.hasWifi) return false;
        if (hasPowerFilter.value && !spot.hasPower) return false;
        if (hasCoffeeFilter.value && !spot.hasCoffee) return false;
        
        // Noise level filter
        if (noiseLevel.value.isNotEmpty && spot.noiseLevel != noiseLevel.value) return false;
        
        // Rating filter
        if (minRating.value > 0 && spot.rating < minRating.value) return false;
        
        return true;
      }).toList();
      
      // Sort the results
      _sortSpots(results);
      
      searchResults.value = results;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Sort spots based on selected sort criteria
  void _sortSpots(List<StudySpot> spots) {
    switch (sortBy.value) {
      case 'name':
        spots.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rating':
        spots.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        if (userLatitude.value != 0 && userLongitude.value != 0) {
          spots.sort((a, b) {
            final distA = _calculateDistance(
              userLatitude.value, userLongitude.value, a.latitude, a.longitude);
            final distB = _calculateDistance(
              userLatitude.value, userLongitude.value, b.latitude, b.longitude);
            return distA.compareTo(distB);
          });
        }
        break;
    }
  }
  
  // Calculate distance between two points using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // const double p = 0.017453292519943295; // Math.PI / 180
    // final double a = 0.5 - (lat2 - lat1).cos() / 2 + 
    //                  (lat1 * p).cos() * (lat2 * p).cos() * 
    //                  (1 - (lon2 - lon1).cos()) / 2;
    // return 12742 * a.asin(); // 2 * R; R = 6371 km


    return 6723;
  }
  
  // Clear all filters
  void clearAllFilters() {
    hasWifiFilter.value = false;
    hasPowerFilter.value = false;
    hasCoffeeFilter.value = false;
    noiseLevel.value = '';
    minRating.value = 0;
    _filterAndSortSpots();
  }
  
  // Clear individual filters
  void clearWifiFilter() {
    hasWifiFilter.value = false;
    _filterAndSortSpots();
  }
  
  void clearPowerFilter() {
    hasPowerFilter.value = false;
    _filterAndSortSpots();
  }
  
  void clearCoffeeFilter() {
    hasCoffeeFilter.value = false;
    _filterAndSortSpots();
  }
  
  void clearNoiseLevelFilter() {
    noiseLevel.value = '';
    _filterAndSortSpots();
  }
  
  void clearRatingFilter() {
    minRating.value = 0;
    _filterAndSortSpots();
  }
}