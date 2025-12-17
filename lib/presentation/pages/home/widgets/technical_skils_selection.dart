import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import 'glass_card.dart';

class TechnicalSkillsSection extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Get.width > 1024 ? 80 : 20,
        vertical: Get.width > 768 ? 100 : 60,
      ),
      child: Obx(() {
        final profile = controller.profile.value;
        if (profile == null || profile.technicalSkills.isEmpty) return SizedBox();

        return Column(
          children: [
            Text(
              'Technical Expertise',
              style: AppTextStyles.headline2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.width > 768 ? 60 : 40),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: profile.technicalSkills.entries.map((entry) {
                    return _buildSkillCard(entry.key, entry.value);
                  }).toList(),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSkillCard(String category, List<String> skills) {
    return GlassCard(
      width: Get.width > 1024 ? 380 : (Get.width > 768 ? Get.width * 0.45 : Get.width * 0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getCategoryIcon(category), color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  category,
                  style: AppTextStyles.headline3.copyWith(
                    fontSize: Get.width > 768 ? 20 : 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width > 768 ? 14 : 12,
        vertical: Get.width > 768 ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple.withOpacity(0.3)),
      ),
      child: Text(
        skill,
        style: AppTextStyles.body2.copyWith(
          fontSize: Get.width > 768 ? 14 : 12,
          color: Colors.white,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mobile development':
        return Icons.phone_android;
      case 'architecture & state management':
        return Icons.architecture;
      case 'backend & services':
        return Icons.cloud;
      case 'maps & tracking':
        return Icons.map;
      case 'databases & tools':
        return Icons.storage;
      case 'languages':
        return Icons.code;
      default:
        return Icons.star;
    }
  }
}