import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:cpdassignment/src/features/home/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('StudySpotCard displays correctly', (WidgetTester tester) async {
    // Create a test StudySpot
    final studySpot = StudySpot(
      id: '1',
      name: 'Test Library',
      address: '123 Test St',
      latitude: 0.0,
      longitude: 0.0,
      imageUrl: 'https://example.com/image.jpg',
      description: 'A test spot',
      rating: 4.5,
      amenities: {'WiFi': true, 'Power': true},
      noiseLevel: 'Quiet',
      openingHours: ['Monday-Friday: 9-5'],
      capacity: 100,
      reviews: [],
      hasWifi: true,
      hasPower: true,
      hasCoffee: false,
      pricePerHour: 0.0,
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeScreen()
        ),
      ),
    );

    // Verify that our widget displays the correct data
    expect(find.text('Test Library'), findsOneWidget);
    expect(find.text('123 Test St'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('Quiet'), findsOneWidget);
    
    // Check for WiFi icon
    expect(find.byIcon(Icons.wifi), findsOneWidget);
  });
}