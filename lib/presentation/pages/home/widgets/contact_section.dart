import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import 'glass_card.dart';

class ContactSection extends GetView<HomeController> {
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
              'Get In Touch',
              style: AppTextStyles.headline2,
            ),
            SizedBox(height: 20),
            Text(
              'Let\'s work together on your next project',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                if (profile.email.isNotEmpty)
                  _ContactCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: profile.email,
                    onTap: () => _launchUrl('mailto:${profile.email}'),
                    isActive: true,
                  ),
                if (profile.linkedin.isNotEmpty)
                  _ContactCard(
                    icon: Icons.link,
                    title: 'LinkedIn',
                    value: 'Connect',
                    onTap: () => _launchUrl(profile.linkedin),
                    isActive: true,
                  )
                else
                  _ContactCard(
                    icon: Icons.link,
                    title: 'LinkedIn',
                    value: 'Not Available',
                    onTap: () {},
                    isActive: false,
                  ),
                if (profile.github.isNotEmpty)
                  _ContactCard(
                    icon: Icons.code,
                    title: 'GitHub',
                    value: 'View Profile',
                    onTap: () => _launchUrl(profile.github),
                    isActive: true,
                  )
                else
                  _ContactCard(
                    icon: Icons.code,
                    title: 'GitHub',
                    value: 'Not Available',
                    onTap: () {},
                    isActive: false,
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('mailto:')) {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool isActive;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isActive ? widget.onTap : null,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: Get.width > 768 ? 280 : Get.width * 0.85,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.glassBackground
                : AppColors.glassBackground.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered && widget.isActive
                  ? AppColors.purple
                  : AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? AppColors.purple.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: widget.isActive ? AppColors.purple : Colors.white30,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.title,
                style: AppTextStyles.headline3.copyWith(
                  fontSize: 20,
                  color: widget.isActive ? Colors.white : Colors.white30,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.value,
                style: AppTextStyles.body2.copyWith(
                  color: widget.isActive ? Colors.white70 : Colors.white30,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}