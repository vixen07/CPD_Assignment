import 'dart:io';
import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:cpdassignment/src/features/home/service/studyspot_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;
final FirebaseDatabase _database = FirebaseDatabase.instance;


class AddSpotController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final capacityController = TextEditingController();
  final weekdayHoursController = TextEditingController();
  final weekendHoursController = TextEditingController();
  
  // Services
  final _studySpotService = StudySpotService();
  final _imagePicker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _location = Location();
  
  // Observable variables
  final isLoading = false.obs;
  final selectedImagePath = ''.obs;
  final noiseLevel = 'Moderate'.obs;
  final hasWifi = true.obs;
  final hasPower = true.obs;
  final hasCoffee = false.obs;
  final hasStudyRooms = false.obs;
  final hasPrinters = false.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
  final hasSetLocation = false.obs;
  
  // Getters
  File? get selectedImageFile => 
      selectedImagePath.value.isNotEmpty ? File(selectedImagePath.value) : null;
  
  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }
  
  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    capacityController.dispose();
    weekdayHoursController.dispose();
    weekendHoursController.dispose();
    super.onClose();
  }
  
  // Get current device location
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
      latitude.value = locationData.latitude ?? 0.0;
      longitude.value = locationData.longitude ?? 0.0;
      hasSetLocation.value = true;
    } catch (e) {
      print('Error getting location: $e');
      Get.snackbar(
        'Error',
        'Could not get current location. Please set location manually.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Pick image from gallery or camera
  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    }
  }
  
  // Upload image to Firebase Storage
final FirebaseDatabase _database = FirebaseDatabase.instance; // Initialize Realtime Database

Future<String> _uploadImage() async {
  if (selectedImageFile == null) {
    return ''; // No image selected
  }

  try {
    final bucketName = 'studyspots';

 
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final fileBytes = await selectedImageFile!.readAsBytes();

    // Check if the bucket exists, if not, create it
    try {
      await supabase.storage.from(bucketName).bucketId;
    } catch (e) {
      // Bucket doesn't exist, so create it
      print('Bucket does not exist, creating bucket...');
      await supabase.storage.createBucket(
        bucketName,
        BucketOptions(public: true), // Set it as public or private as needed
      );
      print('Bucket created successfully');
    }

    // 👇 Upload file to Supabase Storage
    final storageResponse = await supabase.storage
        .from(bucketName) // This is your bucket name
        .uploadBinary(
          'images/$fileName', // Path inside the bucket
          fileBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

    if (storageResponse.isEmpty) {
      throw Exception('Supabase upload failed.');
    }

    // 👇 Generate public URL
    final imageUrl = supabase.storage
        .from(bucketName)
        .getPublicUrl('images/$fileName');

    print('✅ Image uploaded to Supabase: $imageUrl');

    // 👇 Save to Firebase Realtime Database
    final DatabaseReference dbRef = _database.ref().child('study_spots');
    await dbRef.push().set({
      'imageUrl': imageUrl,
      'uploadedAt': DateTime.now().toIso8601String(),
    });

    print('✅ Image URL saved to Realtime Database');

    return imageUrl;

  } catch (e) {
    print('❌ Error uploading image: $e');
    throw Exception('Failed to upload image');
  }
}








Future<String> _uploadImages() async {
  if (selectedImageFile == null) return '';

  try {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = FirebaseStorage.instance.ref().child('study_spots/$fileName');

    print('Uploading to: study_spots/$fileName');
    print('Selected file: ${selectedImageFile!.path}');

    final uploadTask = storageRef.putFile(selectedImageFile!);
    final snapshot = await uploadTask.whenComplete(() => {});
    final imageUrl = await snapshot.ref.getDownloadURL();

    final dbRef = FirebaseDatabase.instance.ref('study_spots');
    await dbRef.push().set({
      'imageUrl': imageUrl,
      'uploadedAt': DateTime.now().toIso8601String(),
    });

    print('Upload successful: $imageUrl');
    return imageUrl;
  } catch (e) {
    print('Error uploading image: $e');
    throw Exception('Failed to upload image');
  }
}






















  
  // Pick location from map
  void pickLocation() async {
    // In a real app, you would show a map and let the user pick a location
    // For this example, we'll just show a dialog to input coordinates
    
    final TextEditingController latController = TextEditingController(
      text: latitude.value != 0.0 ? latitude.value.toString() : '',
    );
    final TextEditingController lngController = TextEditingController(
      text: longitude.value != 0.0 ? longitude.value.toString() : '',
    );
    
    Get.dialog(
      AlertDialog(
        title: Text('Set Location'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: latController,
              decoration: InputDecoration(
                labelText: 'Latitude',
                hintText: 'Enter latitude',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: lngController,
              decoration: InputDecoration(
                labelText: 'Longitude',
                hintText: 'Enter longitude',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (latController.text.isNotEmpty && lngController.text.isNotEmpty) {
                try {
                  latitude.value = double.parse(latController.text);
                  longitude.value = double.parse(lngController.text);
                  hasSetLocation.value = true;
                  Get.back();
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Please enter valid coordinates',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              } else {
                Get.snackbar(
                  'Error',
                  'Please enter both latitude and longitude',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Set'),
          ),
        ],
      ),
    );
  }
  
  // Validate form fields
  bool _validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter spot name');
      return false;
    }
    
    if (addressController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter spot address');
      return false;
    }
    
    if (descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter spot description');
      return false;
    }
    
    if (!hasSetLocation.value) {
      Get.snackbar('Error', 'Please set location');
      return false;
    }
    
    if (weekdayHoursController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter weekday hours');
      return false;
    }
    
    if (weekendHoursController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter weekend hours');
      return false;
    }
    
    return true;
  }
  
  // Submit the spot to Firebase
  Future<void> submitSpot() async {
    if (!_validateForm()) {
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Upload image if selected
      String imageUrl = '';
      if (selectedImageFile != null) {
        imageUrl = await _uploadImage();
      }
      
      // Parse price and capacity
      double price = 0.0;
      int capacity = 0;
      
      try {
        if (priceController.text.isNotEmpty) {
          price = double.parse(priceController.text);
        }
        
        if (capacityController.text.isNotEmpty) {
          capacity = int.parse(capacityController.text);
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Please enter valid price and capacity values',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }
      
      // Create opening hours list
      final openingHours = [
        weekdayHoursController.text,
        weekendHoursController.text
      ];
      
      // Create amenities map
      final amenities = {
        'Study Rooms': hasStudyRooms.value,
        'Printers': hasPrinters.value,
        'Free WiFi': hasWifi.value,
        'Power Outlets': hasPower.value,
        'Coffee Available': hasCoffee.value,
      };
      
      // Create study spot
      final spot = StudySpot(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        name: nameController.text,
        address: addressController.text,
        latitude: latitude.value,
        longitude: longitude.value,
        imageUrl: imageUrl.isNotEmpty 
            ? imageUrl 
            : 'https://images.unsplash.com/photo-1497366811353-6870744d04b2', // Default image
        description: descriptionController.text,
        rating: 0.0, // New spot starts with no rating
        amenities: amenities,
        noiseLevel: noiseLevel.value,
        openingHours: openingHours,
        capacity: capacity,
        reviews: [],
        hasWifi: hasWifi.value,
        hasPower: hasPower.value,
        hasCoffee: hasCoffee.value,
        pricePerHour: price,
      );
      
      // Add spot to Firestore
      await _studySpotService.addStudySpot(spot);
      
      Get.snackbar(
        'Success',
        'Study spot added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Navigate back to home screen
      Get.offAllNamed('/home');
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add study spot: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Clear form fields
  void clearForm() {
    nameController.clear();
    addressController.clear();
    descriptionController.clear();
    priceController.clear();
    capacityController.clear();
    weekdayHoursController.clear();
    weekendHoursController.clear();
    selectedImagePath.value = '';
    noiseLevel.value = 'Moderate';
    hasWifi.value = true;
    hasPower.value = true;
    hasCoffee.value = false;
    hasStudyRooms.value = false;
    hasPrinters.value = false;
  }
}