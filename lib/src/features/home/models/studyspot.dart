class StudySpot {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String description;
  final double rating;
  final Map<String, bool> amenities;
  final String noiseLevel;
  final List<String> openingHours;
  final int capacity;
  final List<String> reviews;
  final bool hasWifi;
  final bool hasPower;
  final bool hasCoffee;
  final double pricePerHour;
  
  StudySpot({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.amenities,
    required this.noiseLevel,
    required this.openingHours,
    required this.capacity,
    required this.reviews,
    required this.hasWifi,
    required this.hasPower,
    required this.hasCoffee,
    required this.pricePerHour,
  });
  
  // Create StudySpot from Map (for Firebase)
  factory StudySpot.fromMap(Map<String, dynamic> map, String id) {
    return StudySpot(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      amenities: Map<String, bool>.from(map['amenities'] ?? {}),
      noiseLevel: map['noiseLevel'] ?? 'Moderate',
      openingHours: List<String>.from(map['openingHours'] ?? []),
      capacity: map['capacity'] ?? 0,
      reviews: List<String>.from(map['reviews'] ?? []),
      hasWifi: map['hasWifi'] ?? false,
      hasPower: map['hasPower'] ?? false,
      hasCoffee: map['hasCoffee'] ?? false,
      pricePerHour: map['pricePerHour']?.toDouble() ?? 0.0,
    );
  }
  
  // Convert StudySpot to Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'amenities': amenities,
      'noiseLevel': noiseLevel,
      'openingHours': openingHours,
      'capacity': capacity,
      'reviews': reviews,
      'hasWifi': hasWifi,
      'hasPower': hasPower,
      'hasCoffee': hasCoffee,
      'pricePerHour': pricePerHour,
    };
  }
}