import 'package:cpdassignment/src/features/home/controllers/spotdetails_controller.dart';
import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class SpotDetailsScreen extends StatelessWidget {
  const SpotDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StudySpot spot = Get.arguments;
    final controller = Get.put(SpotDetailsController(spot));
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                spot.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[500],
                    size: 50.sp,
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              // Bookmark button
              Obx(() => Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    controller.isBookmarked.value 
                        ? Icons.bookmark 
                        : Icons.bookmark_border,
                    color: controller.isBookmarked.value 
                        ? Theme.of(context).primaryColor 
                        : Colors.black,
                  ),
                  onPressed: controller.toggleBookmark,
                ),
              )),
              // Like button
              Obx(() => Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    controller.isLiked.value 
                        ? Icons.favorite 
                        : Icons.favorite_border,
                    color: controller.isLiked.value 
                        ? Colors.red 
                        : Colors.black,
                  ),
                  onPressed: controller.toggleLike,
                ),
              )),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
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
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            spot.rating.toString(),
                            style: TextStyle(
                              fontSize: 18.sp,
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
                        size: 18.sp,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          spot.address,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    spot.description,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Amenities
                  Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildAmenitiesGrid(spot),
                  
                  SizedBox(height: 24.h),
                  
                  // Opening hours
                  Text(
                    'Opening Hours',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...spot.openingHours.map((hours) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      hours,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[800],
                      ),
                    ),
                  )),
                  
                  SizedBox(height: 24.h),
                  
                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.addReview,
                        child: Text(
                          'Add Review',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ...spot.reviews.map((review) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        review,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  )),
                  
                  SizedBox(height: 24.h),
                  
                  // Pricing information
                  if (spot.pricePerHour > 0) ...[
                    Text(
                      'Pricing',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${spot.pricePerHour} per hour',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Reserve button at the bottom
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: controller.reserveSpot,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Reserve a Spot',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Grid of amenities
  Widget _buildAmenitiesGrid(StudySpot spot) {
    final amenities = [
      {'icon': Icons.wifi, 'name': 'WiFi', 'available': spot.hasWifi},
      {'icon': Icons.power, 'name': 'Power Outlets', 'available': spot.hasPower},
      {'icon': Icons.local_cafe, 'name': 'Coffee', 'available': spot.hasCoffee},
      {'icon': Icons.volume_down, 'name': 'Noise Level', 'value': spot.noiseLevel},
      {'icon': Icons.people, 'name': 'Capacity', 'value': '${spot.capacity} people'},
    ];
    
    // Add other amenities from the amenities map
    spot.amenities.forEach((key, value) {
      if (value) {
        amenities.add({
          'icon': Icons.check_circle,
          'name': key,
          'available': true,
        });
      }
    });
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final amenity = amenities[index];
        return Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                amenity['icon'] as IconData,
                color: amenity.containsKey('available') 
                    ? (amenity['available'] as bool ? Colors.green : Colors.grey) 
                    : Colors.blue,
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                amenity.containsKey('value') 
                    ? (amenity['value'] as String) 
                    : (amenity['name'] as String),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}