import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find<StorageService>();
  final _box = GetStorage();

  // Example methods for using GetStorage
  Future<void> saveUserToken(String token) async {
    await _box.write('user_token', token);
  }

  String? getUserToken() {
    return _box.read<String>('user_token');
  }

  Future<void> clearUserData() async {
    await _box.remove('user_token');
    // Remove other user-related data
  }

  // Add more methods as needed for your app
}