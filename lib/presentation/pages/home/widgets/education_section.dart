import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import 'glass_card.dart';

class EducationSection extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width > 1024 ? 80 : 20,
        vertical: Get.width > 768 ? 100 : 60,
      ),
      child: Column(
        children: [
          Text(
            'Education',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Get.width > 768 ? 60 : 40),
          Obx(() {
            if (controller.educations.isEmpty) {
              return Center(
                child: Text(
                  'No education data available',
                  style: AppTextStyles.body1,
                ),
              );
            }

            return Column(
              children: controller.educations.asMap().entries.map((entry) {
                final edu = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: Get.width > 768 ? 24 : 16),
                  child: _buildEducationCard(edu),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEducationCard(edu) {
    final isDesktop = Get.width > 1024;
    final isTablet = Get.width > 768 && Get.width <= 1024;
    final isMobile = Get.width <= 768;

    return GlassCard(
      padding: EdgeInsets.all(Get.width > 768 ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            _buildMobileLayout(edu),
          ] else if (isTablet) ...[
            _buildTabletLayout(edu),
          ] else ...[
            _buildDesktopLayout(edu),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(edu) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.cyan, AppColors.purple],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.school,
            color: Colors.white,
            size: 40,
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                edu.degree,
                style: AppTextStyles.headline3.copyWith(fontSize: 22),
              ),
              SizedBox(height: 4),
              Text(
                edu.field,
                style: AppTextStyles.body1.copyWith(color: AppColors.cyan),
              ),
              SizedBox(height: 8),
              Text(
                edu.institution,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 12),
              Text(
                edu.description,
                style: AppTextStyles.body2,
              ),
            ],
          ),
        ),
        SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (edu.isCurrently)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.purple),
                ),
                child: Text(
                  'Currently',
                  style: TextStyle(color: AppColors.purple, fontSize: 12),
                ),
              ),
            SizedBox(height: 8),
            Text(
              '${edu.startDate} - ${edu.endDate ?? 'Present'}',
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout(edu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cyan, AppColors.purple],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    edu.degree,
                    style: AppTextStyles.headline3.copyWith(fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    edu.field,
                    style: AppTextStyles.body2.copyWith(color: AppColors.cyan),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          edu.institution,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            if (edu.isCurrently)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.purple),
                ),
                child: Text(
                  'Currently',
                  style: TextStyle(color: AppColors.purple, fontSize: 11),
                ),
              ),
            SizedBox(width: 12),
            Text(
              '${edu.startDate} - ${edu.endDate ?? 'Present'}',
              style: AppTextStyles.body2.copyWith(fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          edu.description,
          style: AppTextStyles.body2.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(edu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cyan, AppColors.purple],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    edu.degree,
                    style: AppTextStyles.headline3.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    edu.field,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.cyan,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          edu.institution,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (edu.isCurrently)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.purple),
                ),
                child: Text('Currently', style: TextStyle(color: AppColors.purple, fontSize: 10)),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Text(
                '${edu.startDate} - ${edu.endDate ?? 'Present'}',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          edu.description,
          style: AppTextStyles.body2.copyWith(fontSize: 13),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}