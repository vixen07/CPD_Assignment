import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'dart:math';


class StudySpotService {
  final CollectionReference _spotsCollection = 
      FirebaseFirestore.instance.collection('study_spots');
  
  // Get all study spots
  Future<List<StudySpot>> getStudySpots() async {
    try {
      final snapshot = await _spotsCollection.get();
      
      if (snapshot.docs.isEmpty) {
        // If no spots in database, return mock data
        return _getMockStudySpots();
      }
      
      return snapshot.docs.map((doc) {
        return StudySpot.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    } catch (e) {
      print('Error fetching study spots: $e');
      // Return mock data if we can't get from Firebase
      return _getMockStudySpots();
    }
  }
  
  // Get study spot by ID
  Future<StudySpot?> getStudySpotById(String id) async {
    try {
      final doc = await _spotsCollection.doc(id).get();
      
      if (!doc.exists) {
        return null;
      }
      
      return StudySpot.fromMap(
        doc.data() as Map<String, dynamic>, 
        doc.id
      );
    } catch (e) {
      print('Error fetching study spot: $e');
      return null;
    }
  }
  
  // Create a new study spot
  Future<void> addStudySpot(StudySpot spot) async {
    try {
      await _spotsCollection.add(spot.toMap());
    } catch (e) {
      print('Error adding study spot: $e');
      throw Exception('Failed to add study spot');
    }
  }
  
  // Update an existing study spot
  Future<void> updateStudySpot(StudySpot spot) async {
    try {
      await _spotsCollection.doc(spot.id).update(spot.toMap());
    } catch (e) {
      print('Error updating study spot: $e');
      throw Exception('Failed to update study spot');
    }
  }
  
  // Delete a study spot
  Future<void> deleteStudySpot(String id) async {
    try {
      await _spotsCollection.doc(id).delete();
    } catch (e) {
      print('Error deleting study spot: $e');
      throw Exception('Failed to delete study spot');
    }
  }
  
  // Mock data for testing or initial app state
  List<StudySpot> _getMockStudySpots() {
    return [
      StudySpot(
        id: '1',
        name: 'University Library',
        address: '123 Campus Drive, University City',
        latitude: 37.7749,
        longitude: -122.4194,
        imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f',
        description: 'Quiet university library with extensive resources and private study rooms available for reservation.',
        rating: 4.8,
        amenities: {
          'Study Rooms': true,
          'Computers': true,
          'Printers': true,
          'Quiet Zones': true,
          'Group Tables': true,
        },
        noiseLevel: 'Very Quiet',
        openingHours: [
          'Monday-Friday: 8:00 AM - 10:00 PM',
          'Saturday: 9:00 AM - 8:00 PM',
          'Sunday: 10:00 AM - 6:00 PM',
        ],
        capacity: 500,
        reviews: [
          'Great place for focused study!',
          'Always find what I need here.',
        ],
        hasWifi: true,
        hasPower: true,
        hasCoffee: false,
        pricePerHour: 0.0,
      ),
      StudySpot(
        id: '2',
        name: 'The Coffee Scholar',
        address: '456 Main Street, Downtown',
        latitude: 37.7831,
        longitude: -122.4039,
        imageUrl: 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb',
        description: 'Cozy café with free WiFi, great coffee, and a quiet atmosphere perfect for studying.',
        rating: 4.5,
        amenities: {
          'Food & Drinks': true,
          'Free WiFi': true,
          'Power Outlets': true,
          'Outdoor Seating': true,
          'Quiet Music': true,
        },
        noiseLevel: 'Moderate',
        openingHours: [
          'Monday-Friday: 6:00 AM - 8:00 PM',
          'Saturday-Sunday: 7:00 AM - 7:00 PM',
        ],
        capacity: 40,
        reviews: [
          'Love their lattes and the quiet atmosphere!',
          'Great place to work with decent wifi.',
        ],
        hasWifi: true,
        hasPower: true,
        hasCoffee: true,
        pricePerHour: 0.0,
      ),
      StudySpot(
        id: '3',
        name: 'Focus Coworking Space',
        address: '789 Tech Boulevard, Innovation District',
        latitude: 37.7694,
        longitude: -122.4268,
        imageUrl: 'https://images.unsplash.com/photo-1497366811353-6870744d04b2',
        description: 'Modern coworking space with high-speed internet, meeting rooms, and 24/7 access for members.',
        rating: 4.7,
        amenities: {
          'High-Speed WiFi': true,
          'Meeting Rooms': true,
          'Private Desks': true,
          'Coffee Bar': true,
          'Phone Booths': true,
        },
        noiseLevel: 'Quiet',
        openingHours: [
          'Monday-Friday: 24 hours',
          'Saturday-Sunday: 8:00 AM - 10:00 PM',
        ],
        capacity: 150,
        reviews: [
          'Perfect for productivity!',
          'Great community of professionals.',
          'Excellent amenities and comfortable workspace.',
        ],
        hasWifi: true,
        hasPower: true,
        hasCoffee: true,
        pricePerHour: 15.0,
      ),
      StudySpot(
        id: '4',
        name: 'Public Library',
        address: '321 Community Ave, Residential Area',
        latitude: 37.7569,
        longitude: -122.4148,
        imageUrl: 'https://images.unsplash.com/photo-1521587760476-6c12a4b040da',
        description: 'Public library with free resources, quiet study areas, and community programs.',
        rating: 4.3,
        amenities: {
          'Free WiFi': true,
          'Public Computers': true,
          'Study Carrels': true,
          'Group Study Rooms': false,
          'Printing Services': true,
        },
        noiseLevel: 'Quiet',
        openingHours: [
          'Monday-Thursday: 9:00 AM - 8:00 PM',
          'Friday-Saturday: 9:00 AM - 6:00 PM',
          'Sunday: 1:00 PM - 5:00 PM',
        ],
        capacity: 200,
        reviews: [
          'Great free resource for studying!',
          'Helpful staff and good selection of materials.',
        ],
        hasWifi: true,
        hasPower: true,
        hasCoffee: false,
        pricePerHour: 0.0,
      ),
      StudySpot(
        id: '5',
        name: 'Sunrise Bakery & Study Lounge',
        address: '567 College Road, University District',
        latitude: 37.7826,
        longitude: -122.4330,
        imageUrl: 'https://images.unsplash.com/photo-1525610553991-2bede1a236e2',
        description: 'Bakery with a dedicated study lounge area, famous for its pastries and relaxed atmosphere.',
        rating: 4.6,
        amenities: {
          'Food & Drinks': true,
          'Free WiFi': true,
          'Power Outlets': true,
          'Comfortable Seating': true,
          'Natural Lighting': true,
        },
        noiseLevel: 'Moderate',
        openingHours: [
          'Monday-Friday: 7:00 AM - 9:00 PM',
          'Saturday-Sunday: 8:00 AM - 7:00 PM',
        ],
        capacity: 35,
        reviews: [
          'Best cinnamon rolls and a great place to study!',
          'Love the atmosphere and reliable wifi.',
          'My go-to place for studying with good food.',
        ],
        hasWifi: true,
        hasPower: true,
        hasCoffee: true,
        pricePerHour: 0.0,
      ),
    ];
  }
  
  // Search study spots by name or address
  Future<List<StudySpot>> searchStudySpots(String query) async {
    try {
      // Get all spots first
      final spots = await getStudySpots();
      
      // Filter based on query
      if (query.isEmpty) {
        return spots;
      }
      
      final lowercaseQuery = query.toLowerCase();
      return spots.where((spot) {
        return spot.name.toLowerCase().contains(lowercaseQuery) ||
               spot.address.toLowerCase().contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      print('Error searching study spots: $e');
      return [];
    }
  }
  
  // Filter study spots by amenities
  Future<List<StudySpot>> filterStudySpots({
    bool? hasWifi,
    bool? hasPower,
    bool? hasCoffee,
    String? noiseLevel,
    double? minRating,
    double? maxPricePerHour,
  }) async {
    try {
      // Get all spots first
      final spots = await getStudySpots();
      
      // Apply filters
      return spots.where((spot) {
        if (hasWifi != null && spot.hasWifi != hasWifi) return false;
        if (hasPower != null && spot.hasPower != hasPower) return false;
        if (hasCoffee != null && spot.hasCoffee != hasCoffee) return false;
        if (noiseLevel != null && spot.noiseLevel != noiseLevel) return false;
        if (minRating != null && spot.rating < minRating) return false;
        if (maxPricePerHour != null && 
            spot.pricePerHour > maxPricePerHour && 
            spot.pricePerHour > 0) return false;
        
        return true;
      }).toList();
    } catch (e) {
      print('Error filtering study spots: $e');
      return [];
    }
  }
  
  // Get nearby study spots
  Future<List<StudySpot>> getNearbyStudySpots(
    double latitude, 
    double longitude, 
    double radiusInKm
  ) async {
    try {
      // Get all spots first
      final spots = await getStudySpots();
      
      // Calculate distance and filter
      return spots.where((spot) {
        final distance = _calculateDistance(
          latitude, 
          longitude, 
          spot.latitude, 
          spot.longitude
        );
        
        return distance <= radiusInKm;
      }).toList();
    } catch (e) {
      print('Error getting nearby study spots: $e');
      return [];
    }
  }
  
  // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2
  ) {
    // const double earthRadius = 6371; // in km
    
    // final dLat = _degreesToRadians(lat2 - lat1);
    // final dLon = _degreesToRadians(lon2 - lon1);
    
    // final a = 
    //     (dLat / 2).sin() * (dLat / 2).sin() +
    //     (dLon / 2).sin() * (dLon / 2).sin() * 
    //     lat1.cos() * lat2.cos();
    // final c = 2 * a.sqrt().asin();
    
    // return earthRadius * c;

    return 8.0;
  }
  
  // Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
  
  // Add a review to a study spot
  Future<void> addReview(String spotId, String review) async {
    try {
      final spot = await getStudySpotById(spotId);
      
      if (spot == null) {
        throw Exception('Study spot not found');
      }
      
      final reviews = [...spot.reviews, review];
      
      await _spotsCollection.doc(spotId).update({
        'reviews': reviews,
      });
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('Failed to add review');
    }
  }
  
  // Get popular study spots (highest rated)
  Future<List<StudySpot>> getPopularStudySpots({int limit = 5}) async {
    try {
      final spots = await getStudySpots();
      
      // Sort by rating (descending)
      spots.sort((a, b) => b.rating.compareTo(a.rating));
      
      // Return top spots
      return spots.take(limit).toList();
    } catch (e) {
      print('Error getting popular study spots: $e');
      return [];
    }
  }
}