import 'package:cpdassignment/src/services/storage_service.dart';
import 'package:get/get.dart';


class DependencyInjection {
  static Future<void> init() async {
    await Get.putAsync(() => StorageService().init());
  
  }
}
extension GetxServiceExtension on GetxService {
  Future<T> init<T>() async => this as T;
}