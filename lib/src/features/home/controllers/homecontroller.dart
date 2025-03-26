import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:cpdassignment/src/features/home/service/studyspot_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class HomeController extends GetxController {
  // Map controller
  GoogleMapController? mapController;
  
  // Observable variables
  final isLoading = true.obs;
  final currentLocation = Rx<LatLng?>(null);
  final selectedSpot = Rx<StudySpot?>(null);
  final showSpotDetails = false.obs;
  final spots = <StudySpot>[].obs;
  final markers = <Marker>{}.obs;
  
  // Services
  final _studySpotService = StudySpotService();
  final _location = Location();
  
  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
    _loadStudySpots();
  }
  
  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
  
  // Initialize user's current location
  Future<void> _initializeLocation() async {
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
    try {
      final locationData = await _location.getLocation();
      currentLocation.value = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
    } catch (e) {
      print('Error getting location: $e');
      // Default to a central location if we can't get the user's location
      currentLocation.value = const LatLng(37.7749, -122.4194); // San Francisco
    }
  }
  
  // Load study spots from service
  Future<void> _loadStudySpots() async {
    try {
      isLoading.value = true;
      final loadedSpots = await _studySpotService.getStudySpots();
      spots.value = loadedSpots;
      _createMarkers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load study spots: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Create map markers from study spots
  void _createMarkers() {
    final newMarkers = spots.map((spot) {
      return Marker(
        markerId: MarkerId(spot.id),
        position: LatLng(spot.latitude, spot.longitude),
        infoWindow: InfoWindow(title: spot.name),
        onTap: () => _onMarkerTapped(spot),
      );
    }).toSet();
    
    markers.value = newMarkers;
  }
  
  // Handle marker tap
  void _onMarkerTapped(StudySpot spot) {
    selectedSpot.value = spot;
    showSpotDetails.value = true;
  }
  
  // Close spot details
  void closeSpotDetails() {
    showSpotDetails.value = false;
  }
  
  // Navigate to spot details page
  void navigateToSpotDetails() {
    if (selectedSpot.value != null) {
      Get.toNamed('/spot-details', arguments: selectedSpot.value);
    }
  }
  
  // Navigate to add spot page
  void navigateToAddSpot() {
    Get.toNamed('/add-spot');
  }
  
  // Navigate to user profile
  void navigateToProfile() {
    Get.toNamed('/profile');
  }
  
  // Navigate to favorites
  void navigateToFavorites() {
    Get.toNamed('/favorites');
  }
  
  // Navigate to search
  void navigateToSearch() {
    Get.toNamed('/search');
  }
  
  // Set map controller when map is created
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  // Refresh study spots
  Future<void> refreshSpots() async {
    await _loadStudySpots();
  }
  
  // Move camera to specific location
  void animateToLocation(LatLng location) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 15,
        ),
      ),
    );
  }
  
  // Move camera to current location
  void goToCurrentLocation() {
    if (currentLocation.value != null) {
      animateToLocation(currentLocation.value!);
    }
  }
}