import 'package:cpdassignment/src/features/home/controllers/favourite_controller.dart';
import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.favoriteSpots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  'No Favorite Spots Yet',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Tap the heart icon on any study spot to add it to favorites',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed('/home'),
                  icon: Icon(Icons.search),
                  label: Text('Find Study Spots'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: controller.refreshFavorites,
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.favoriteSpots.length,
            itemBuilder: (context, index) {
              final spot = controller.favoriteSpots[index];
              return _buildSpotCard(context, spot, controller);
            },
          ),
        );
      }),
    );
  }
  
  Widget _buildSpotCard(BuildContext context, StudySpot spot, FavoritesController controller) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => Get.toNamed('/spot-details', arguments: spot),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spot image with favorite button overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: Image.network(
                    spot.imageUrl,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150.h,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[500],
                        size: 50.sp,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () => controller.removeFromFavorites(spot),
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          spot.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            spot.rating.toString(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          spot.address,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Noise level and capacity
                  Row(
                    children: [
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
                      SizedBox(width: 16.w),
                      Icon(
                        Icons.people,
                        color: Colors.green,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Capacity: ${spot.capacity}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12.h),
                  
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
                        icon: Icons.coffee,
                        label: 'Coffee',
                        isAvailable: spot.hasCoffee,
                      ),
                      if (spot.pricePerHour > 0)
                        _buildAmenityIcon(
                          icon: Icons.attach_money,
                          label: '\$${spot.pricePerHour}/hr',
                          isAvailable: true,
                        )
                      else
                        _buildAmenityIcon(
                          icon: Icons.money_off,
                          label: 'Free',
                          isAvailable: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Build an amenity icon with label
  Widget _buildAmenityIcon({
    required IconData icon,
    required String label,
    required bool isAvailable,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: isAvailable ? Colors.green : Colors.grey[400],
          size: 18.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          isAvailable ? label : 'No $label',
          style: TextStyle(
            fontSize: 12.sp,
            color: isAvailable ? Colors.black87 : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}