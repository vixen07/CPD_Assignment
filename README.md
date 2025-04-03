# StudySpot - Find Your Perfect Study Space

## Overview

StudySpot is a Flutter application designed to help students and professionals discover ideal study environments based on their specific needs. The application provides a comprehensive platform for finding study locations through an intuitive map interface, advanced filtering options, and detailed location information. Users can explore various study spots, save their favorites, and make informed decisions about where to study based on amenities, noise levels, and other important factors.

Our application solves a common challenge faced by students and working professionals: finding suitable environments that enhance productivity and focus. By aggregating information about libraries, cafes, co-working spaces, and other study-friendly locations, StudySpot helps users make better decisions about where to spend their study time.

## Features

### Core Functionality

* **Map-Based Discovery**: Explore study locations visually on an interactive map with custom markers indicating different types of study spots
* **Detailed Information**: Access comprehensive details about each location including amenities, noise levels, operating hours, and capacity
* **Advanced Search & Filtering**: Find the perfect study spot using filters for amenities, noise preferences, and ratings
* **Bookmarking System**: Save favorite spots for quick access during future planning
* **Like & Preference System**: Build a personalized profile by liking spots that match your preferences

### Technical Implementation

* **Responsive UI**: Fully responsive design that adapts to different screen sizes using Flutter ScreenUtil
* **State Management**: Efficient reactive programming using GetX for clean, maintainable code
* **Local Storage**: Persistent data storage with GetStorage for offline access and preference management
* **Location Services**: Accurate location tracking and permission handling for proximity-based recommendations
* **Local Notifications**: In-app notifications to confirm user actions and enhance engagement
* **Performance Optimization**: Efficient resource management for smooth operation across various devices

## Getting Started

### Prerequisites

* Flutter SDK (version 3.10.0 or higher)
* Dart SDK (version 3.0.0 or higher)
* Google Maps API key
* Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:

```bash
git clone https://github.com/vixen07/CPD_Assignment.git
cd CPD_Assignment
```

2. Install dependencies:

```bash
flutter pub get
```

3. Configure Google Maps API:
   - Obtain an API key from the Google Cloud Console
   - Add the key to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`

4. Run the application:

```bash
flutter run
```

## Key Components

### Map Interface

The core of our application is an interactive map that displays study locations as custom markers. Users can:

* Pan and zoom to explore different areas
* See their current location clearly marked
* Tap markers to view brief information cards
* Access detailed screens for comprehensive location information

The map implementation is optimized for performance, using techniques like marker clustering and region-based loading to ensure smooth operation even in areas with numerous study spots.

### Study Spot Details

Each study location features a detailed profile including:

* High-quality images of the space
* Complete list of available amenities with visual indicators
* Operating hours organized by weekdays and weekends
* Noise level classification
* Capacity information
* Option to bookmark or like the location

### Search and Filtering

Our advanced search system allows users to filter study spots based on:

* Amenities (WiFi, power outlets, coffee availability)
* Noise levels (from very quiet to somewhat loud)
* Minimum rating thresholds
* Distance from current location

Results can be viewed either on the map or as a scrollable list, with sorting options for name, rating, or proximity.

### Local Notifications

The application incorporates a local notification system that provides immediate feedback when users interact with study spots, enhancing engagement and providing clear confirmation of actions taken.

## Architecture

StudySpot follows a clean architecture pattern with clear separation of concerns:

* **Models**: Data structures representing study spots and user preferences
* **Views**: UI components built with Flutter widgets
* **Controllers**: Business logic handling user interactions and data manipulation
* **Services**: External integrations and utility functions

This architecture ensures code maintainability and facilitates future enhancements.

## Dependencies

The application uses the following key packages:

* **flutter_screenutil**: For responsive UI design
* **get**: For state management, navigation, and dependency injection
* **get_storage**: For local data persistence
* **google_maps_flutter**: For map integration
* **location**: For device location services
* **flutter_local_notifications**: For notification management
* **cached_network_image**: For efficient image loading and caching

## Future Enhancements

Our development roadmap includes several planned enhancements:

1. **Advanced Search Capabilities**:
   - Filter by opening hours and real-time availability
   - Heat map visualization showing popular study times
   - More granular noise level indicators

2. **Social Features**:
   - Study group creation and management
   - Photo uploads with reviews
   - Friend system to see study patterns

3. **Real-time Updates**:
   - Current occupancy information
   - Crowd-sourced noise level reporting
   - Reservation system for participating locations

## Conclusion

StudySpot addresses the challenge of finding suitable study environments through a comprehensive, user-friendly platform. By focusing on a clean interface, powerful filtering capabilities, and reliable performance, the application delivers a valuable service to students and professionals seeking productive spaces.

Through continued development and user feedback, we aim to make StudySpot the definitive tool for discovering and sharing great study locations, enhancing productivity and learning experiences for our users.
