import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../widgets/animated_blob.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/glass_button.dart';
import '../../../widgets/network_image_with_fallback.dart';
import '../../../controllers/home_controller.dart';
import 'glass_card.dart';

class HeroSection extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = Get.width > 1024;
    final isTablet = Get.width > 768 && Get.width <= 1024;

    return Container(
      height: Get.height,
      width: double.infinity,
      child: Obx(() {
        final profile = controller.profile.value;
        if (profile == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            Positioned(
              top: -100,
              right: -100,
              child: AnimatedBlob(
                color: AppColors.purple,
                size: isDesktop ? 400 : 300,
                duration: Duration(seconds: 6),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: AnimatedBlob(
                color: AppColors.cyan,
                size: isDesktop ? 500 : 350,
                duration: Duration(seconds: 8),
              ),
            ),
            Positioned(
              top: Get.height * 0.3,
              right: Get.width * 0.1,
              child: AnimatedBlob(
                color: AppColors.pink,
                size: isDesktop ? 300 : 200,
                duration: Duration(seconds: 7),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width > 1024 ? 80 : 20),
              child: Center(
                child: isDesktop
                    ? _buildDesktopLayout(profile)
                    : _buildMobileLayout(profile),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDesktopLayout(profile) {
    return Row(
      children: [
        Expanded(
          child: _buildTextContent(profile),
        ),
        SizedBox(width: 80),
        Expanded(
          child: _buildImageSection(profile),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 100),
          _buildImageSection(profile, size: Get.width * 0.7),
          SizedBox(height: 40),
          _buildTextContent(profile),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTextContent(profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: Get.width > 1024 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'Hello, I\'m',
          style: AppTextStyles.body1,
        ),
        SizedBox(height: 8),
        Text(
          profile.name,
          style: AppTextStyles.headline1,
          textAlign: Get.width > 1024 ? TextAlign.left : TextAlign.center,
        ),
        SizedBox(height: 16),
        GradientText(
          text: profile.role,
          style: AppTextStyles.headline2,
          gradient: AppColors.gradientColors,
        ),
        SizedBox(height: 24),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Text(
            profile.bio,
            style: AppTextStyles.body1,
            textAlign: Get.width > 1024 ? TextAlign.left : TextAlign.center,
          ),
        ),
        SizedBox(height: 40),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: Get.width > 1024 ? WrapAlignment.start : WrapAlignment.center,
          children: [
            GlassButton(
              text: 'Hire Me',
              onPressed: () => _launchUrl(profile.hireMeUrl),
              isPrimary: true,
              width: Get.width > 768 ? 180 : Get.width * 0.4,
              height: 50,
            ),
            GlassButton(
              text: 'Download CV',
              onPressed: () => _launchUrl(profile.cvUrl),
              width: Get.width > 768 ? 180 : Get.width * 0.4,
              height: 50,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageSection(profile, {double? size}) {
    final imageSize = size ?? 400.0;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: NetworkImageWithFallback(
                imageUrl: profile.imageUrl,
                width: imageSize,
                height: imageSize,
                fallbackIcon: Icons.person,
                fallbackIconSize: imageSize * 0.4,
              ),
            ),
          ),
          if (Get.width > 600)
            Positioned(
              bottom: 20,
              right: 20,
              child: GlassCard(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${profile.yearsExperience}+',
                      style: AppTextStyles.headline3.copyWith(fontSize: Get.width > 768 ? 24 : 18),
                    ),
                    Text(
                      'Years Experience',
                      style: AppTextStyles.body2.copyWith(fontSize: Get.width > 768 ? 14 : 10),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) {
      Get.snackbar(
        'Not Available',
        'This link is not configured yet',
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}