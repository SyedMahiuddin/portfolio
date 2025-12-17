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
            SizedBox(height: Get.width > 768 ? 40 : 30),
            _buildBioSection(profile.bio),
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
                    children: _buildStatCards(profile).asMap().entries.map((entry) =>
                        Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: entry.value,
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

  Widget _buildBioSection(String bio) {
    return Container(
      constraints: BoxConstraints(maxWidth: 900),
      padding: EdgeInsets.all(Get.width > 768 ? 32 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.purple.withOpacity(0.1),
            AppColors.cyan.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.purple, AppColors.cyan],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Professional Summary',
                style: AppTextStyles.headline3.copyWith(
                  fontSize: Get.width > 768 ? 24 : 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            bio,
            style: AppTextStyles.body1.copyWith(
              height: 1.8,
              fontSize: Get.width > 768 ? 18 : 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatCards(profile) {
    return [
      _StatCard(
        value: '${profile.yearsExperience}+',
        label: 'Years Experience',
        icon: Icons.work_outline,
        index: 0,
      ),
      _StatCard(
        value: profile.location,
        label: 'Based In',
        icon: Icons.location_on_outlined,
        index: 1,
      ),
      _TechStackCard(index: 2),
      _StatCard(
        value: '${profile.projectsCompleted}+',
        label: 'Projects Delivered',
        icon: Icons.apps,
        index: 3,
      ),
    ];
  }
}

class _StatCard extends StatefulWidget {
  final String value;
  final String label;
  final IconData icon;
  final int index;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.index,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    final colors = [AppColors.purple, AppColors.cyan, AppColors.pink, Color(0xFF10b981)];
    return colors[widget.index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isMobile = Get.width < 600;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered ? color.withOpacity(0.6) : color.withOpacity(0.2),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: _isHovered
                    ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: _isHovered
                          ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 15,
                        )
                      ]
                          : [],
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: isMobile ? 28 : 32,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.value,
                    style: AppTextStyles.headline3.copyWith(
                      fontSize: isMobile ? 24 : 32,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.label,
                    style: AppTextStyles.body2.copyWith(
                      fontSize: isMobile ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TechStackCard extends StatefulWidget {
  final int index;

  const _TechStackCard({required this.index});

  @override
  State<_TechStackCard> createState() => _TechStackCardState();
}

class _TechStackCardState extends State<_TechStackCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor() {
    final colors = [AppColors.purple, AppColors.cyan, AppColors.pink, Color(0xFF10b981)];
    return colors[widget.index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isMobile = Get.width < 600;

    final techStack = [
      {'name': 'Android', 'icon': Icons.android},
      {'name': 'iOS', 'icon': Icons.apple},
      {'name': 'Web', 'icon': Icons.language},
    ];

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: EdgeInsets.all(isMobile ? 20 : 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.1),
                    color.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered ? color.withOpacity(0.6) : color.withOpacity(0.2),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: _isHovered
                    ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: techStack.map((tech) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 8),
                        padding: EdgeInsets.all(isMobile ? 14 : 18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isHovered
                              ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 12,
                            )
                          ]
                              : [],
                        ),
                        child: Icon(
                          tech['icon'] as IconData,
                          color: Colors.white,
                          size: isMobile ? 28 : 32,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tech Stack',
                    style: AppTextStyles.headline3.copyWith(
                      fontSize: isMobile ? 18 : 20,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}