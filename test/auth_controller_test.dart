import 'package:cpdassignment/src/features/auth/controllers/authentication_controller.dart';
import 'package:cpdassignment/src/utils/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Create a mock for AuthService
class MockAuthService extends Mock implements AuthService {}
class MockUser extends Mock implements User {}

void main() {
  late AuthController authController;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    authController = AuthController();
  });

  group('AuthController Tests', () {
    test('signIn - success', () async {
      // Arrange
    when(mockAuthService.signInWithEmailAndPassword(
  'test@example.com', 'password123'
)).thenAnswer((_) async => MockUser()); // Returning a mocked User

      // Act
      final result = await authController.login(email: 'example@example.com', password: 'myPassword');

      // Assert
      expect(result, true);
      verify(mockAuthService.signInWithEmailAndPassword(
        'test@example.com', 'password123'
      )).called(1);
    });

    test('signIn - failure', () async {
      // Arrange
      when(mockAuthService.signInWithEmailAndPassword(
        'wrong@example.com', 'password123'
      )).thenThrow(Exception('Invalid credentials'));

      // Act & Assert
      expect(
        () => authController.login(email: 'example@example.com', password: 'myPassword'),
        throwsException
      );
    });
  });
}