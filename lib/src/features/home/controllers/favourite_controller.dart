import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:cpdassignment/src/features/home/service/studyspot_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class FavoritesController extends GetxController {
  // Services
  final _studySpotService = StudySpotService();
  final _storage = GetStorage();
  
  // Observable variables
  final isLoading = false.obs;
  final favoriteSpots = <StudySpot>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadFavoriteSpots();
  }
  
  // Load favorite spots from storage and fetch their details
  Future<void> loadFavoriteSpots() async {
    try {
      isLoading.value = true;
      
      // Get bookmarked spot IDs from storage
      final bookmarkedIds = _getBookmarkedSpotIds();
      
      if (bookmarkedIds.isEmpty) {
        favoriteSpots.clear();
        return;
      }
      
      // Fetch spot details for each bookmarked ID
      final spots = <StudySpot>[];
      
      for (final id in bookmarkedIds) {
        final spot = await _studySpotService.getStudySpotById(id);
        if (spot != null) {
          spots.add(spot);
        }
      }
      
      // Sort by name alphabetically
      spots.sort((a, b) => a.name.compareTo(b.name));
      
      // Update the observable list
      favoriteSpots.value = spots;
      
    } catch (e) {
      print('Error loading favorite spots: $e');
      Get.snackbar(
        'Error',
        'Failed to load favorite spots',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Get bookmarked spot IDs from storage
  List<String> _getBookmarkedSpotIds() {
    final bookmarkedSpots = _storage.read<List<dynamic>>('bookmarked_spots');
    if (bookmarkedSpots == null) {
      return [];
    }
    return bookmarkedSpots.map((id) => id.toString()).toList();
  }
  
  // Remove a spot from favorites
  void removeFromFavorites(StudySpot spot) {
    final bookmarkedIds = _getBookmarkedSpotIds();
    
    // Remove the spot ID from the list
    bookmarkedIds.remove(spot.id);
    
    // Save updated list to storage
    _storage.write('bookmarked_spots', bookmarkedIds);
    
    // Remove from the observable list
    favoriteSpots.removeWhere((s) => s.id == spot.id);
    
    // Show confirmation
    Get.snackbar(
      'Removed',
      '${spot.name} removed from favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Refresh the favorites list
  Future<void> refreshFavorites() async {
    await loadFavoriteSpots();
  }
}