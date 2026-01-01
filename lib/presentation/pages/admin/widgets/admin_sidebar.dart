import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';

class AdminSidebar extends GetView<AdminController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: Color(0xFF0D1117),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: AppColors.gradientColors,
                    ),
                  ),
                  child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Admin Panel',
                  style: AppTextStyles.headline3.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.glassBorder),
          Expanded(
            child: Obx(() => ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  icon: Icons.person,
                  title: 'Profile',
                  index: 0,
                  isSelected: controller.selectedTab.value == 0,
                ),
                _buildMenuItem(
                  icon: Icons.work,
                  title: 'Projects',
                  index: 1,
                  isSelected: controller.selectedTab.value == 1,
                ),
                _buildMenuItem(
                  icon: Icons.business_center,
                  title: 'Experience',
                  index: 2,
                  isSelected: controller.selectedTab.value == 2,
                ),
                _buildMenuItem(
                  icon: Icons.mail,
                  title: 'Messages',
                  index: 3,
                  isSelected: controller.selectedTab.value == 3,
                  badge: controller.unreadCount.value > 0 ? controller.unreadCount.value : null,
                ),
                _buildMenuItem(
                  icon: Icons.school,
                  title: 'Education',
                  index: 4,
                  isSelected: controller.selectedTab.value == 4,
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  index: 5,
                  isSelected: controller.selectedTab.value == 5,
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Team',
                  index: 6,
                  isSelected: controller.selectedTab.value == 5,
                ),
              ],
            )),
          ),
          Divider(color: AppColors.glassBorder),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: controller.logout,
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    int? badge,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.purple.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: AppColors.purple, width: 1) : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.purple : Colors.white70),
        title: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.purple : Colors.white70,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (badge != null) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () => Get.find<AdminController>().selectedTab.value = index,
      ),
    );
  }
}