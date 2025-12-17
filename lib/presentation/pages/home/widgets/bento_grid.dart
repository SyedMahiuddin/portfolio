import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import 'glass_card.dart';

class BentoGrid extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width > 1024 ? 80 : 20,
        vertical: Get.width > 768 ? 100 : 60,
      ),
      child: Obx(() {
        final profile = controller.profile.value;
        if (profile == null) return SizedBox();

        return Column(
          children: [
            Text(
              'About Me',
              style: AppTextStyles.headline2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.width > 768 ? 60 : 40),
            LayoutBuilder(
              builder: (context, constraints) {
                if (Get.width > 1024) {
                  return GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1.2,
                    children: _buildStatCards(profile),
                  );
                } else if (Get.width > 600) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.3,
                    children: _buildStatCards(profile),
                  );
                } else {
                  return Column(
                    children: _buildStatCards(profile).map((card) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: card,
                        ),
                    ).toList(),
                  );
                }
              },
            ),
          ],
        );
      }),
    );
  }

  List<Widget> _buildStatCards(profile) {
    return [
      _buildStatCard(
        '${profile.yearsExperience}+',
        'Years Experience',
        Icons.work_outline,
      ),
      _buildStatCard(
        profile.location,
        'Based In',
        Icons.location_on_outlined,
      ),
      _buildTechStackCard(),
      _buildStatCard(
        '${profile.projectsCompleted}+',
        'Projects Delivered',
        Icons.apps,
      ),
    ];
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.purple,
            size: Get.width > 768 ? 40 : 30,
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.headline3.copyWith(
              fontSize: Get.width > 768 ? 32 : 24,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackCard() {
    final techIcons = [
      Icons.flutter_dash,
      Icons.code,
      Icons.design_services,
    ];

    return GlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: techIcons
                .map((icon) => Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width > 768 ? 8 : 4),
              child: Icon(
                icon,
                color: AppColors.cyan,
                size: Get.width > 768 ? 32 : 24,
              ),
            ))
                .toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Tech Stack',
            style: AppTextStyles.headline3.copyWith(
              fontSize: Get.width > 768 ? 24 : 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Flutter & Firebase',
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}