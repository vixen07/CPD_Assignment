import 'package:cpdassignment/src/features/home/models/studyspot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchScreenController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Study Spots'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or address',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: controller.clearSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  onChanged: controller.onSearchChanged,
                ),
                
                SizedBox(height: 16.h),
                
                // Filter row
                Row(
                  children: [
                    // Filters button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showFilterDialog(context, controller),
                        icon: Icon(Icons.filter_list),
                        label: Text('Filters'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    // Sort dropdown
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Obx(() => DropdownButton<String>(
                          value: controller.sortBy.value,
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Text('Sort By'),
                          items: [
                            DropdownMenuItem(
                              value: 'name',
                              child: Text('Name'),
                            ),
                            DropdownMenuItem(
                              value: 'rating',
                              child: Text('Rating'),
                            ),
                            DropdownMenuItem(
                              value: 'distance',
                              child: Text('Distance'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.sortBy.value = value;
                              controller.applySorting();
                            }
                          },
                        )),
                      ),
                    ),
                  ],
                ),
                
                // Active filters
                Obx(() => controller.hasActiveFilters
                  ? Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Row(
                        children: [
                          Text(
                            'Active filters:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Container(
                              height: 30.h,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  if (controller.hasWifiFilter.value)
                                    _buildFilterChip('WiFi', controller.clearWifiFilter),
                                  if (controller.hasPowerFilter.value)
                                    _buildFilterChip('Power', controller.clearPowerFilter),
                                  if (controller.hasCoffeeFilter.value)
                                    _buildFilterChip('Coffee', controller.clearCoffeeFilter),
                                  if (controller.noiseLevel.value.isNotEmpty)
                                    _buildFilterChip(
                                      controller.noiseLevel.value,
                                      controller.clearNoiseLevelFilter,
                                    ),
                                  if (controller.minRating.value > 0)
                                    _buildFilterChip(
                                      '${controller.minRating.value}+ Stars',
                                      controller.clearRatingFilter,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.clearAllFilters,
                            child: Text('Clear All'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50.w, 30.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
                ),
              ],
            ),
          ),
          
          // Results
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No Results Found',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Try changing your search or filters',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final spot = controller.searchResults[index];
                  return _buildSearchResultItem(context, spot);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  // Build filter chip with close button
  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(width: 4.w),
          InkWell(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build search result item
  Widget _buildSearchResultItem(BuildContext context, StudySpot spot) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => Get.toNamed('/spot-details', arguments: spot),
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Spot image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              child: Image.network(
                spot.imageUrl,
                width: 120.w,
                height: 120.w,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120.w,
                  height: 120.w,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey[500],
                    size: 30.sp,
                  ),
                ),
              ),
            ),
            
            // Spot details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
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
                              fontSize: 16.sp,
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
                              size: 18.sp,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              spot.rating.toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Address
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[600],
                          size: 14.sp,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            spot.address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Noise level
                    Row(
                      children: [
                        Icon(
                          Icons.volume_down,
                          color: Colors.blue,
                          size: 14.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          spot.noiseLevel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Amenities row
                    Row(
                      children: [
                        if (spot.hasWifi)
                          _buildAmenityBadge(Icons.wifi, 'WiFi'),
                        if (spot.hasPower)
                          _buildAmenityBadge(Icons.power, 'Power'),
                        if (spot.hasCoffee)
                          _buildAmenityBadge(Icons.coffee, 'Coffee'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Build amenity badge
  Widget _buildAmenityBadge(IconData icon, String label) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.sp,
            color: Colors.green,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }
  
  // Show filter dialog
  void _showFilterDialog(BuildContext context, SearchScreenController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Options',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  
                  Divider(),
                  
                  // Amenities section
                  Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  //// Amenities checkboxes
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('WiFi'),
                          value: controller.hasWifiFilter.value,
                          onChanged: (value) {
                            setState(() {
                              controller.hasWifiFilter.value = value ?? false;
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('Power'),
                          value: controller.hasPowerFilter.value,
                          onChanged: (value) {
                            setState(() {
                              controller.hasPowerFilter.value = value ?? false;
                            });
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  
                  CheckboxListTile(
                    title: Text('Coffee Available'),
                    value: controller.hasCoffeeFilter.value,
                    onChanged: (value) {
                      setState(() {
                        controller.hasCoffeeFilter.value = value ?? false;
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Noise level section
                  Text(
                    'Noise Level',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  Wrap(
                    spacing: 8.w,
                    children: [
                      _buildNoiseChip('Very Quiet', controller, setState),
                      _buildNoiseChip('Quiet', controller, setState),
                      _buildNoiseChip('Moderate', controller, setState),
                      _buildNoiseChip('Somewhat Loud', controller, setState),
                      _buildNoiseChip('Loud', controller, setState),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Rating section
                  Text(
                    'Minimum Rating',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  
                  Obx(() => Slider(
                    value: controller.minRating.value,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: controller.minRating.value.toString(),
                    onChanged: (value) {
                      setState(() {
                        controller.minRating.value = value;
                      });
                    },
                  )),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Any'),
                      Text('5 Stars'),
                    ],
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Apply and reset buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.clearAllFilters();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text('Reset'),
                        ),
                      ),
                      
                      SizedBox(width: 12.w),
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.applyFilters();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // Build noise level chip for filter dialog
  Widget _buildNoiseChip(String level, SearchScreenController controller, StateSetter setState) {
    final isSelected = controller.noiseLevel.value == level;
    
    return ChoiceChip(
      label: Text(level),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          controller.noiseLevel.value = selected ? level : '';
        });
      },
      selectedColor: Get.theme.primaryColor.withOpacity(0.2),
    );
  }
}