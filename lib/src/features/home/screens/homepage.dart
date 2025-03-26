import 'package:cpdassignment/src/features/home/controllers/homecontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Stack(
          children: [
            // Map View
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.currentLocation.value ?? 
                    const LatLng(37.7749, -122.4194), // Default to San Francisco if no location
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              markers: controller.markers,
              onMapCreated: controller.onMapCreated,
            ),
            
            // App Bar
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Profile button
                    GestureDetector(
                      onTap: controller.navigateToProfile,
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    
                    // Search bar (takes most of the space)
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.navigateToSearch,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.grey[600],
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Search study spots...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 16.w),
                    
                    // Favorites button
                    GestureDetector(
                      onTap: controller.navigateToFavorites,
                      child: Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).primaryColor,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Study spot details card (shown when marker is tapped)
            Obx(() => controller.showSpotDetails.value
              ? _buildSpotDetailsCard(context, controller)
              : const SizedBox.shrink()
            ),
          ],
        );
      }),
      
      // Floating action buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Add new study spot button
          FloatingActionButton(
            onPressed: () => controller.navigateToAddSpot(),
            heroTag: 'addSpot',
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 16.h),
          
          // Current location button
          FloatingActionButton(
            onPressed: () => controller.goToCurrentLocation(),
            heroTag: 'currentLocation',
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
  
  // Build the details card that appears when a marker is tapped
  Widget _buildSpotDetailsCard(BuildContext context, HomeController controller) {
    final spot = controller.selectedSpot.value;
    
    if (spot == null) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 20.h,
      left: 20.w,
      right: 20.w,
      child: GestureDetector(
        onTap: controller.navigateToSpotDetails,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row with image, name, and close button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spot image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      spot.imageUrl,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80.w,
                        height: 80.w,
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  
                  // Spot name and details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spot.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              spot.rating.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Icon(
                              Icons.volume_down,
                              color: Colors.blue,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              spot.noiseLevel,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          spot.address,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Close button
                  GestureDetector(
                    onTap: controller.closeSpotDetails,
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[600],
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // Amenities row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAmenityIcon(
                    icon: Icons.wifi,
                    label: 'WiFi',
                    isAvailable: spot.hasWifi,
                  ),
                  _buildAmenityIcon(
                    icon: Icons.power,
                    label: 'Power',
                    isAvailable: spot.hasPower,
                  ),
                  _buildAmenityIcon(
                    icon: Icons.local_cafe,
                    label: 'Coffee',
                    isAvailable: spot.hasCoffee,
                  ),
                  _buildAmenityIcon(
                    icon: Icons.people,
                    label: 'Capacity',
                    value: '${spot.capacity}',
                  ),
                  _buildAmenityIcon(
                    icon: Icons.attach_money,
                    label: 'Price',
                    value: spot.pricePerHour > 0 ? '\$${spot.pricePerHour}/hr' : 'Free',
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              // View details button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.navigateToSpotDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Build an amenity icon with label
  Widget _buildAmenityIcon({
    required IconData icon,
    required String label,
    bool isAvailable = true,
    String? value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isAvailable ? Colors.green : Colors.grey[400],
          size: 20.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          value ?? (isAvailable ? label : 'No $label'),
          style: TextStyle(
            fontSize: 12.sp,
            color: isAvailable ? Colors.black87 : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}