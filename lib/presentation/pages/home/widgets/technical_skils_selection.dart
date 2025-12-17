import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import 'dart:math' as math;

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
            SizedBox(height: Get.width > 768 ? 20 : 16),
            Text(
              'Technologies & Tools I Work With',
              style: AppTextStyles.body1.copyWith(color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.width > 768 ? 60 : 40),
            _buildSkillsGrid(profile.technicalSkills),
          ],
        );
      }),
    );
  }

  Widget _buildSkillsGrid(Map<String, List<String>> skills) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        double spacing = 24;

        if (Get.width < 600) {
          crossAxisCount = 1;
          spacing = 16;
        } else if (Get.width < 900) {
          crossAxisCount = 2;
          spacing = 20;
        } else if (Get.width < 1200) {
          crossAxisCount = 2;
          spacing = 24;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: Get.width < 600 ? 1.1 : 1.0,
          ),
          itemCount: skills.length,
          itemBuilder: (context, index) {
            final entry = skills.entries.elementAt(index);
            return _SkillCard(
              category: entry.key,
              skills: entry.value,
              index: index,
            );
          },
        );
      },
    );
  }
}

class _SkillCard extends StatefulWidget {
  final String category;
  final List<String> skills;
  final int index;

  const _SkillCard({
    required this.category,
    required this.skills,
    required this.index,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getGradientColor() {
    final colors = [
      AppColors.purple,
      AppColors.pink,
      AppColors.cyan,
      Color(0xFF10b981),
      Color(0xFFf59e0b),
      Color(0xFFef4444),
    ];
    return colors[widget.index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Get.width < 600;
    final gradientColor = _getGradientColor();

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _isHovered ? _rotationAnimation.value : 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      gradientColor.withOpacity(0.1),
                      gradientColor.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: _isHovered
                        ? gradientColor.withOpacity(0.6)
                        : gradientColor.withOpacity(0.2),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                    BoxShadow(
                      color: gradientColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                gradientColor.withOpacity(0.2),
                                gradientColor.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                gradientColor.withOpacity(0.15),
                                gradientColor.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(isMobile ? 20 : 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        gradientColor,
                                        gradientColor.withOpacity(0.5),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.category,
                                    style: AppTextStyles.headline3.copyWith(
                                      fontSize: isMobile ? 18 : 20,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isMobile ? 16 : 20),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: isMobile ? 8 : 10,
                                  runSpacing: isMobile ? 8 : 10,
                                  children: widget.skills.map((skill) {
                                    return _SkillChip(
                                      skill: skill,
                                      color: gradientColor,
                                      isHovered: _isHovered,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.skills.length} skills',
                                  style: TextStyle(
                                    fontSize: isMobile ? 11 : 12,
                                    color: Colors.white38,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: gradientColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: gradientColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Active',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: gradientColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;
  final Color color;
  final bool isHovered;

  const _SkillChip({
    required this.skill,
    required this.color,
    required this.isHovered,
  });

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isChipHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Get.width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => _isChipHovered = true),
      onExit: (_) => setState(() => _isChipHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 14,
          vertical: isMobile ? 7 : 8,
        ),
        decoration: BoxDecoration(
          color: _isChipHovered
              ? widget.color.withOpacity(0.25)
              : widget.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isChipHovered
                ? widget.color.withOpacity(0.6)
                : widget.color.withOpacity(0.3),
            width: _isChipHovered ? 1.5 : 1,
          ),
        ),
        child: Text(
          widget.skill,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            color: _isChipHovered ? Colors.white : Colors.white.withOpacity(0.9),
            fontWeight: _isChipHovered ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}