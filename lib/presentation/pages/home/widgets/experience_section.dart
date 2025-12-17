import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import 'glass_card.dart';

class ExperienceSection extends GetView<HomeController> {
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
            'Work Experience',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Get.width > 768 ? 60 : 40),
          Obx(() {
            if (controller.experiences.isEmpty) {
              return Center(
                child: Text(
                  'No experience data available',
                  style: AppTextStyles.body1,
                ),
              );
            }

            return Column(
              children: controller.experiences.asMap().entries.map((entry) {
                final exp = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: Get.width > 768 ? 24 : 16),
                  child: _buildExperienceCard(exp),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(exp) {
    final isDesktop = Get.width > 1024;
    final isTablet = Get.width > 768 && Get.width <= 1024;
    final isMobile = Get.width <= 768;

    return GlassCard(
      padding: EdgeInsets.all(Get.width > 768 ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            _buildMobileLayout(exp),
          ] else if (isTablet) ...[
            _buildTabletLayout(exp),
          ] else ...[
            _buildDesktopLayout(exp),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(exp) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradientColors,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.business,
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
                exp.position,
                style: AppTextStyles.headline3.copyWith(fontSize: 22),
              ),
              SizedBox(height: 8),
              Text(
                exp.company,
                style: AppTextStyles.body1.copyWith(color: AppColors.purple),
              ),
              SizedBox(height: 12),
              Text(
                exp.description,
                style: AppTextStyles.body2,
              ),
            ],
          ),
        ),
        SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (exp.isCurrently)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cyan),
                ),
                child: Text(
                  'Currently',
                  style: TextStyle(color: AppColors.cyan, fontSize: 12),
                ),
              ),
            SizedBox(height: 8),
            Text(
              '${exp.startDate} - ${exp.endDate ?? 'Present'}',
              style: AppTextStyles.body2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout(exp) {
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
                  colors: AppColors.gradientColors,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.business,
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
                    exp.position,
                    style: AppTextStyles.headline3.copyWith(fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    exp.company,
                    style: AppTextStyles.body2.copyWith(color: AppColors.purple),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            if (exp.isCurrently)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cyan),
                ),
                child: Text(
                  'Currently',
                  style: TextStyle(color: AppColors.cyan, fontSize: 11),
                ),
              ),
            SizedBox(width: 12),
            Text(
              '${exp.startDate} - ${exp.endDate ?? 'Present'}',
              style: AppTextStyles.body2.copyWith(fontSize: 13),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          exp.description,
          style: AppTextStyles.body2.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(exp) {
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
                  colors: AppColors.gradientColors,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.business,
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
                    exp.position,
                    style: AppTextStyles.headline3.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    exp.company,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.purple,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (exp.isCurrently)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cyan),
                ),
                child: Text(
                  'Currently',
                  style: TextStyle(color: AppColors.cyan, fontSize: 10),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Text(
                '${exp.startDate} - ${exp.endDate ?? 'Present'}',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          exp.description,
          style: AppTextStyles.body2.copyWith(fontSize: 13),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}