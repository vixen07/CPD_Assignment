import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cpdassignment/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end tests', () {
    testWidgets('Login flow test', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find login fields and button
      final emailField = find.byKey(ValueKey('email_field'));
      final passwordField = find.byKey(ValueKey('password_field'));
      final loginButton = find.byKey(ValueKey('login_button'));

      // Enter text in fields
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify we're on the home screen
      expect(find.text('StudySpot'), findsOneWidget);
      expect(find.byType(GoogleMap), findsOneWidget);
    });
  });
}