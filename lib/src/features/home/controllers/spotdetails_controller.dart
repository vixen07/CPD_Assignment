import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:cpdassignment/src/features/home/service/studyspot_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class SpotDetailsController extends GetxController {
  final StudySpot spot;
  final _storage = GetStorage();
  final _studySpotService = StudySpotService();
  
  // Observable variables
  final isBookmarked = false.obs;
  final isLiked = false.obs;
  
  SpotDetailsController(this.spot);
  
  @override
  void onInit() {
    super.onInit();
    _checkBookmarkStatus();
    _checkLikeStatus();
  }
  
  // Check if the spot is bookmarked
  void _checkBookmarkStatus() {
    final bookmarkedSpots = _getBookmarkedSpots();
    isBookmarked.value = bookmarkedSpots.contains(spot.id);
  }
  
  // Check if the spot is liked
  void _checkLikeStatus() {
    final likedSpots = _getLikedSpots();
    isLiked.value = likedSpots.contains(spot.id);
  }
  
  // Get bookmarked spots from storage
  List<String> _getBookmarkedSpots() {
    final bookmarkedSpots = _storage.read<List<dynamic>>('bookmarked_spots');
    if (bookmarkedSpots == null) {
      return [];
    }
    return bookmarkedSpots.map((id) => id.toString()).toList();
  }
  
  // Get liked spots from storage
  List<String> _getLikedSpots() {
    final likedSpots = _storage.read<List<dynamic>>('liked_spots');
    if (likedSpots == null) {
      return [];
    }
    return likedSpots.map((id) => id.toString()).toList();
  }
  
  // Toggle bookmark status
  void toggleBookmark() {
    final bookmarkedSpots = _getBookmarkedSpots();
    
    if (isBookmarked.value) {
      // Remove from bookmarks
      bookmarkedSpots.remove(spot.id);
      isBookmarked.value = false;
      Get.snackbar(
        'Removed',
        '${spot.name} removed from bookmarks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Add to bookmarks
      bookmarkedSpots.add(spot.id);
      isBookmarked.value = true;
      Get.snackbar(
        'Bookmarked',
        '${spot.name} added to bookmarks',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    
    // Save updated bookmarks
    _storage.write('bookmarked_spots', bookmarkedSpots);
  }
  
  // Toggle like status
  void toggleLike() {
    final likedSpots = _getLikedSpots();
    
    if (isLiked.value) {
      // Remove like
      likedSpots.remove(spot.id);
      isLiked.value = false;
      Get.snackbar(
        'Unliked',
        'You unliked ${spot.name}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Add like
      likedSpots.add(spot.id);
      isLiked.value = true;
      Get.snackbar(
        'Liked',
        'You liked ${spot.name}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    
    // Save updated likes
    _storage.write('liked_spots', likedSpots);
  }
  
  // Add a review
  void addReview() {
    final TextEditingController reviewController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text('Add Review'),
        content: TextField(
          controller: reviewController,
          decoration: InputDecoration(
            hintText: 'Write your review here...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reviewController.text.isNotEmpty) {
                _submitReview(reviewController.text);
                Get.back();
              } else {
                Get.snackbar(
                  'Error',
                  'Review cannot be empty',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
  
  // Submit a review to the database
  void _submitReview(String review) async {
    try {
      await _studySpotService.addReview(spot.id, review);
      
      // Update the local spot object
      spot.reviews.add(review);
      
      Get.snackbar(
        'Success',
        'Your review has been added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add review: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Reserve a spot
  void reserveSpot() {
    // Show date and time picker
    Get.dialog(
      AlertDialog(
        title: Text('Reserve a Spot'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select date and time:'),
            SizedBox(height: 16),
            // Simple implementation - would need a proper datetime picker in a real app
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: Get.context!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                    },
                    child: Text('Choose Date'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showTimePicker(
                        context: Get.context!,
                        initialTime: TimeOfDay.now(),
                      );
                    },
                    child: Text('Choose Time'),
                  ),
                ),
              ],
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
              Get.back();
              // Show confirmation in a real app you would save the reservation
              Get.snackbar(
                'Reserved',
                'Your spot at ${spot.name} has been reserved',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Reserve'),
          ),
        ],
      ),
    );
  }
  
  // Share spot with friends
  void shareSpot() {
    // In a real app, you would use a sharing plugin
    Get.snackbar(
      'Share',
      'Sharing ${spot.name} with your friends',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Get directions to spot
  void getDirections() {
    // In a real app, you would launch a maps application
    Get.snackbar(
      'Directions',
      'Getting directions to ${spot.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}