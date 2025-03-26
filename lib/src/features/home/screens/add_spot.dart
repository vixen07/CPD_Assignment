import 'package:cpdassignment/src/features/home/controllers/addspot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddSpotScreen extends StatelessWidget {
  const AddSpotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddSpotController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Study Spot'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image upload section
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 200.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Obx(() => controller.selectedImagePath.value.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50.sp,
                              color: Colors.grey[500],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Add Spot Photo',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            controller.selectedImageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Form fields
                Text(
                  'Spot Information',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Name field
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter spot name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.business),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Address field
                TextField(
                  controller: controller.addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    hintText: 'Enter spot address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Description field
                TextField(
                  controller: controller.descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter spot description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Noise level dropdown
                DropdownButtonFormField<String>(
                  value: controller.noiseLevel.value,
                  decoration: InputDecoration(
                    labelText: 'Noise Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.volume_up),
                  ),
                  items: [
                    'Very Quiet',
                    'Quiet',
                    'Moderate',
                    'Somewhat Loud',
                    'Loud'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.noiseLevel.value = newValue;
                    }
                  },
                ),
                SizedBox(height: 16.h),
                
                // Price per hour field
                TextField(
                  controller: controller.priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price per Hour (0 for free)',
                    hintText: 'Enter price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Capacity field
                TextField(
                  controller: controller.capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Capacity',
                    hintText: 'Enter maximum capacity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.people),
                  ),
                ),
                SizedBox(height: 24.h),
                
                // Amenities section
                Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // WiFi checkbox
                Obx(() => CheckboxListTile(
                  title: Text('WiFi'),
                  value: controller.hasWifi.value,
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.hasWifi.value = value;
                    }
                  },
                  secondary: Icon(Icons.wifi),
                )),
                
                // Power outlets checkbox
                Obx(() => CheckboxListTile(
                  title: Text('Power Outlets'),
                  value: controller.hasPower.value,
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.hasPower.value = value;
                    }
                  },
                  secondary: Icon(Icons.power),
                )),
                
                // Coffee checkbox
                Obx(() => CheckboxListTile(
                  title: Text('Coffee Available'),
                  value: controller.hasCoffee.value,
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.hasCoffee.value = value;
                    }
                  },
                  secondary: Icon(Icons.coffee),
                )),
                
                // Study rooms checkbox
                Obx(() => CheckboxListTile(
                  title: Text('Study Rooms'),
                  value: controller.hasStudyRooms.value,
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.hasStudyRooms.value = value;
                    }
                  },
                  secondary: Icon(Icons.meeting_room),
                )),
                
                // Printers checkbox
                Obx(() => CheckboxListTile(
                  title: Text('Printers'),
                  value: controller.hasPrinters.value,
                  onChanged: (bool? value) {
                    if (value != null) {
                      controller.hasPrinters.value = value;
                    }
                  },
                  secondary: Icon(Icons.print),
                )),
                
                // Opening hours section
                SizedBox(height: 24.h),
                Text(
                  'Opening Hours',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Weekday hours
                TextField(
                  controller: controller.weekdayHoursController,
                  decoration: InputDecoration(
                    labelText: 'Weekday Hours',
                    hintText: 'e.g., Monday-Friday: 8:00 AM - 10:00 PM',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Weekend hours
                TextField(
                  controller: controller.weekendHoursController,
                  decoration: InputDecoration(
                    labelText: 'Weekend Hours',
                    hintText: 'e.g., Saturday-Sunday: 9:00 AM - 6:00 PM',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Location picker section
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                // Map preview (would be a Google Map widget in a real app)
                GestureDetector(
                  onTap: controller.pickLocation,
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 40.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Tap to set location on map',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Obx(() => controller.hasSetLocation.value 
                          ? Text(
                              'Location set: ${controller.latitude.value.toStringAsFixed(6)}, ${controller.longitude.value.toStringAsFixed(6)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox.shrink()
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 40.h),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: controller.submitSpot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Add Study Spot',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
              ],
            ),
          ),
      ),
    );
  }
}