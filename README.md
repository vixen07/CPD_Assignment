# StudySpot - Find Your Perfect Study Space

## Overview

StudySpot is a Flutter application designed to help students and professionals find, reserve, and collaborate in ideal study spaces. The app offers a seamless experience for discovering study spots based on preferences like noise level, amenities, and location, with the ability to book spaces in advance and connect with fellow learners.

## Features

### Core Functionality
- **Study Spot Discovery**: Find libraries, cafes, and dedicated study spaces filtered by amenities and preferences
- **Space Reservation**: Book study rooms and spaces in advance to ensure availability
- **Study Group Collaboration**: Connect with study buddies, join or create study groups

### Technical Features
- **Responsive UI**: Fully responsive design that adapts to different screen sizes using Flutter ScreenUtil
- **State Management**: Efficient state management with GetX for reactive programming
- **Local Storage**: Persistent data storage with GetStorage for offline access
- **Authentication**: Secure user authentication and management using Firebase
- **Real-time Updates**: Real-time data synchronization with Firebase Firestore
- **Onboarding Experience**: Engaging introduction to app features for new users


## Getting Started

### Prerequisites
- Flutter SDK (version 3.10.0 or higher)
- Dart SDK (version 3.0.0 or higher)
- Firebase project
- Android Studio / VS Code with Flutter plugins

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

3. Configure Firebase:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Dependencies

The application uses the following key packages:

- **flutter_screenutil**: For responsive UI design
- **get**: For state management, navigation, and dependency injection
- **get_storage**: For local data persistence
- **firebase_core**: For Firebase initialization
- **firebase_auth**: For user authentication
- **cloud_firestore**: For database operations
- **smooth_page_indicator**: For onboarding page indicators

## Development Guidelines

### Coding Style
- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use GetX for state management and navigation
- Implement responsive design using ScreenUtil
- Keep business logic in controllers, separate from UI code

### Git Workflow
- Create feature branches from `develop` branch
- Use descriptive commit messages with type prefixes (feat, fix, docs, style, refactor, test, chore)
- Submit pull requests for code review before merging

## Future Enhancements

- **Map Integration**: Visual representation of study spots on an interactive map
- **Rating System**: Allow users to rate and review study spots
- **Notifications**: Push notifications for reservations and study group activities
- **Advanced Filtering**: Enhanced search and filtering capabilities
- **Offline Mode**: Improved offline functionality for areas with poor connectivity

## License

This project is licensed under the MIT License - see the LICENSE file for details.


## Acknowledgments

- Flutter team for the amazing framework
- GetX library for simplified state management
- All contributors who have helped shape this project