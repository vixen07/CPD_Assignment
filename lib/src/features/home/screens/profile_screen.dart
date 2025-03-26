import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile image
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: controller.profileImageUrl.value.isNotEmpty
                    ? NetworkImage(controller.profileImageUrl.value)
                    : null,
                  child: controller.profileImageUrl.value.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 60.sp,
                        color: Colors.grey[600],
                      )
                    : null,
                ),
                
                SizedBox(height: 16.h),
                
                // User name
                Text(
                  controller.userName.value,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // User email
                Text(
                  controller.userEmail.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Edit profile button
                TextButton.icon(
                  onPressed: controller.editProfile,
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                
                // Divider(height: 32.h),
                
                // Account section
                _buildSection(
                  title: '',
                  items: [
                    {
                      'icon': Icons.favorite,
                      'title': 'My Favorites',
                      'subtitle': 'View your favorite study spots',
                      'onTap': controller.navigateToFavorites,
                    },
                    // {
                    //   'icon': Icons.history,
                    //   'title': 'Activity History',
                    //   'subtitle': 'View your recent activity',
                    //   'onTap': controller.navigateToHistory,
                    // },
                    // {
                    //   'icon': Icons.star,
                    //   'title': 'My Reviews',
                    //   'subtitle': 'Manage your reviews',
                    //   'onTap': controller.navigateToReviews,
                    // },
                    // {
                    //   'icon': Icons.add_business,
                    //   'title': 'My Study Spots',
                    //   'subtitle': 'Manage spots you\'ve added',
                    //   'onTap': controller.navigateToMySpots,
                    // },
                  ],
                ),
                
                SizedBox(height: 16.h),
              
                
                SizedBox(height: 24.h),
                
                // Sign out button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.signOut,
                    icon: Icon(Icons.logout),
                    label: Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      side: BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Delete account button (with caution)
                TextButton(
                  onPressed: controller.deleteAccount,
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                
                SizedBox(height: 32.h),
              ],
            ),
          ),
      ),
    );
  }
  
  // Build a section with title and list of items
  Widget _buildSection({required String title, required List<Map<String, dynamic>> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  color: Get.theme.primaryColor,
                ),
                title: Text(
                  item['title'] as String,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'] as String,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                onTap: item['onTap'] as Function(),
              );
            },
          ),
        ),
      ],
    );
  }
}