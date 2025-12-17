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
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 100),
      child: Column(
        children: [
          Text(
            'Work Experience',
            style: AppTextStyles.headline2,
          ),
          SizedBox(height: 60),
          Obx(() => ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.experiences.length,
            separatorBuilder: (context, index) => SizedBox(height: 24),
            itemBuilder: (context, index) {
              final exp = controller.experiences[index];
              return GlassCard(
                child: Row(
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
                            style: AppTextStyles.headline3
                                .copyWith(fontSize: 24),
                          ),
                          SizedBox(height: 8),
                          Text(
                            exp.company,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.purple,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            exp.description,
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: exp.isCurrently
                                ? AppColors.cyan.withOpacity(0.2)
                                : AppColors.glassBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: exp.isCurrently
                                  ? AppColors.cyan
                                  : AppColors.glassBorder,
                            ),
                          ),
                          child: Text(
                            exp.isCurrently ? 'Currently' : 'Past',
                            style: AppTextStyles.body2,
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
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}