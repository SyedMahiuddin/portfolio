import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../widgets/network_image_with_fallback.dart';
import 'glass_card.dart';

class ProjectsSection extends GetView<HomeController> {
  final RxString selectedFilter = 'all'.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Get.width > 1024 ? 80 : 20,
        vertical: Get.width > 768 ? 100 : 60,
      ),
      child: Column(
        children: [
          _buildSectionHeader(),
          SizedBox(height: Get.width > 768 ? 40 : 30),
          _buildFilterTabs(),
          SizedBox(height: Get.width > 768 ? 60 : 40),
          Obx(() => _buildFilteredProjects()),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.purple, AppColors.cyan],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'PORTFOLIO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Featured Projects',
          style: AppTextStyles.headline2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'Showcasing my best work across different platforms',
          style: AppTextStyles.body1.copyWith(color: Colors.white60),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'value': 'all', 'label': 'All Projects', 'icon': Icons.apps},
      {'value': 'mobile', 'label': 'Mobile', 'icon': Icons.smartphone},
      {'value': 'web', 'label': 'Web', 'icon': Icons.language},
      {'value': 'desktop', 'label': 'Desktop', 'icon': Icons.desktop_windows},
      {'value': 'macos', 'label': 'macOS', 'icon': Icons.laptop_mac},
    ];

    if (Get.width > 768) {
      return Obx(() => Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: filters.map((filter) {
          final isSelected = selectedFilter.value == filter['value'];
          final count = _getProjectCount(filter['value'] as String);

          return _FilterChip(
            label: filter['label'] as String,
            icon: filter['icon'] as IconData,
            count: count,
            isSelected: isSelected,
            onTap: () => selectedFilter.value = filter['value'] as String,
          );
        }).toList(),
      ));
    } else {
      return Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedFilter.value,
            isExpanded: true,
            dropdownColor: Color(0xFF0D1117),
            icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            style: AppTextStyles.body1,
            items: filters.map((filter) {
              final count = _getProjectCount(filter['value'] as String);
              return DropdownMenuItem<String>(
                value: filter['value'] as String,
                child: Row(
                  children: [
                    Icon(filter['icon'] as IconData, size: 20, color: AppColors.purple),
                    SizedBox(width: 12),
                    Text('${filter['label']} ($count)'),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedFilter.value = value;
              }
            },
          ),
        ),
      ));
    }
  }

  int _getProjectCount(String filter) {
    if (filter == 'all') return controller.projects.length;
    return controller.projects.where((p) => p.projectType == filter).length;
  }

  Widget _buildFilteredProjects() {
    final filteredProjects = selectedFilter.value == 'all'
        ? controller.projects
        : controller.projects.where((p) => p.projectType == selectedFilter.value).toList();

    if (filteredProjects.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        double childAspectRatio = 0.85;

        if (Get.width < 600) {
          crossAxisCount = 1;
          childAspectRatio = 1.0;
        } else if (Get.width < 900) {
          crossAxisCount = 2;
          childAspectRatio = 0.9;
        } else if (Get.width < 1200) {
          crossAxisCount = 2;
          childAspectRatio = 0.95;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Get.width > 768 ? 24 : 16,
            mainAxisSpacing: Get.width > 768 ? 24 : 16,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: filteredProjects.length,
          itemBuilder: (context, index) {
            final project = filteredProjects[index];
            return _ProjectCard(
              project: project,
              index: index,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Icon(Icons.filter_list_off, size: 80, color: Colors.white30),
          SizedBox(height: 20),
          Text(
            'No Projects Found',
            style: AppTextStyles.headline3,
          ),
          SizedBox(height: 12),
          Text(
            'No projects match this filter',
            style: AppTextStyles.body1.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected ? AppColors.purple : Colors.white60;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? LinearGradient(
              colors: [AppColors.purple, AppColors.purple.withOpacity(0.7)],
            )
                : null,
            color: widget.isSelected
                ? null
                : (_isHovered ? AppColors.glassBackground : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.purple
                  : (_isHovered ? AppColors.glassBorder : Colors.white24),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: AppColors.purple.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.isSelected ? Colors.white : color,
              ),
              SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  color: widget.isSelected ? Colors.white : color,
                ),
              ),
              SizedBox(width: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected ? Colors.white : AppColors.purple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final project;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.index,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getProjectColor() {
    final colors = [
      AppColors.purple,
      AppColors.cyan,
      AppColors.pink,
      Color(0xFF10b981),
      Color(0xFFf59e0b),
      Color(0xFF8b5cf6),
    ];
    return colors[widget.index % colors.length];
  }

  String _getProjectTypeLabel() {
    switch (widget.project.projectType) {
      case 'mobile':
        return 'MOBILE';
      case 'web':
        return 'WEB';
      case 'desktop':
        return 'DESKTOP';
      case 'macos':
        return 'macOS';
      default:
        return widget.project.projectType.toUpperCase();
    }
  }

  IconData _getProjectTypeIcon() {
    switch (widget.project.projectType) {
      case 'mobile':
        return Icons.smartphone;
      case 'web':
        return Icons.language;
      case 'desktop':
        return Icons.desktop_windows;
      case 'macos':
        return Icons.laptop_mac;
      default:
        return Icons.apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectColor = _getProjectColor();
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
      child: GestureDetector(
        onTap: () => _showProjectDetails(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: projectColor.withOpacity(_isHovered ? 0.3 : 0.1),
                      blurRadius: _elevationAnimation.value,
                      spreadRadius: _isHovered ? 2 : 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.glassBackground,
                          projectColor.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: _isHovered
                            ? projectColor.withOpacity(0.6)
                            : AppColors.glassBorder,
                        width: _isHovered ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                NetworkImageWithFallback(
                                  imageUrl: widget.project.images.isNotEmpty
                                      ? _convertDriveUrl(widget.project.images.first)
                                      : null,
                                  height: Get.width > 768 ? 200 : 180,
                                  width: double.infinity,
                                  fallbackIcon: Icons.code,
                                  fallbackIconSize: 60,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: projectColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: projectColor.withOpacity(0.5),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getProjectTypeIcon(),
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          _getProjectTypeLabel(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(isMobile ? 16 : 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.project.title,
                                      style: AppTextStyles.headline3.copyWith(
                                        fontSize: isMobile ? 18 : 22,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 12),
                                    Expanded(
                                      child: Text(
                                        widget.project.description,
                                        style: AppTextStyles.body2.copyWith(
                                          fontSize: isMobile ? 13 : 14,
                                          height: 1.5,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    _buildProjectActions(projectColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        _buildFloatingActionButton(projectColor),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(Color projectColor) {
    final buttonData = _getPrimaryActionButton();

    if (buttonData == null) return SizedBox();

    return Positioned(
      bottom: 85,
      right: 10,
      child: _FloatingActionButton(
        icon: buttonData['icon'] as IconData,
        label: buttonData['label'] as String,
        color: buttonData['color'] as Color,
        onTap: () => _launchUrl(buttonData['url'] as String),
      ),
    );
  }

  Map<String, dynamic>? _getPrimaryActionButton() {
    switch (widget.project.projectType) {
      case 'mobile':
        if (widget.project.playStoreUrl != null && widget.project.playStoreUrl!.isNotEmpty) {
          return {
            'icon': Icons.shop,
            'label': 'Play Store',
            'url': widget.project.playStoreUrl!,
            'color': Color(0xFF10b981),
          };
        } else if (widget.project.appStoreUrl != null && widget.project.appStoreUrl!.isNotEmpty) {
          return {
            'icon': Icons.apple,
            'label': 'App Store',
            'url': widget.project.appStoreUrl!,
            'color': Color(0xFF3b82f6),
          };
        } else if (widget.project.apkUrl != null && widget.project.apkUrl!.isNotEmpty) {
          return {
            'icon': Icons.download,
            'label': 'Download',
            'url': widget.project.apkUrl!,
            'color': AppColors.purple,
          };
        }
        break;

      case 'web':
        if (widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty) {
          return {
            'icon': Icons.language,
            'label': 'Visit Site',
            'url': widget.project.liveUrl!,
            'color': AppColors.cyan,
          };
        }
        break;

      case 'desktop':
        if (widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty) {
          return {
            'icon': Icons.desktop_windows,
            'label': 'Download',
            'url': widget.project.liveUrl!,
            'color': Color(0xFFf59e0b),
          };
        }
        break;

      case 'macos':
        if (widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty) {
          return {
            'icon': Icons.laptop_mac,
            'label': 'Download',
            'url': widget.project.liveUrl!,
            'color': Colors.white70,
          };
        }
        break;
    }

    return null;
  }

  Widget _buildProjectActions(Color projectColor) {
    final hasLinks = _hasAnyLinks();

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isHovered
                    ? [projectColor.withOpacity(0.8), projectColor]
                    : [projectColor.withOpacity(0.6), projectColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: projectColor.withOpacity(0.4),
                  blurRadius: 12,
                ),
              ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasLinks) ...[
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: projectColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: projectColor.withOpacity(0.5)),
            ),
            child: Icon(
              Icons.open_in_new,
              size: 18,
              color: projectColor,
            ),
          ),
        ],
      ],
    );
  }

  bool _hasAnyLinks() {
    if (widget.project.projectType == 'web') {
      return widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty;
    } else if (widget.project.projectType == 'mobile') {
      return (widget.project.playStoreUrl != null && widget.project.playStoreUrl!.isNotEmpty) ||
          (widget.project.appStoreUrl != null && widget.project.appStoreUrl!.isNotEmpty) ||
          (widget.project.apkUrl != null && widget.project.apkUrl!.isNotEmpty);
    }
    return false;
  }

  void _showProjectDetails() {
    final isMobile = Get.width < 768;
    final projectColor = _getProjectColor();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: isMobile ? 20 : 40,
        ),
        child: Container(
          width: Get.width > 1024 ? 1100 : double.infinity,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF0A0E27),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: projectColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: projectColor.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogHeader(projectColor, isMobile),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Get.width > 768 ? 40 : 24),
                  child: _buildDialogContent(projectColor),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black87,
    );
  }

  Widget _buildDialogHeader(Color projectColor, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            projectColor.withOpacity(0.2),
            projectColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          bottom: BorderSide(color: projectColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [projectColor, projectColor.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getProjectTypeIcon(),
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.title,
                  style: AppTextStyles.headline3.copyWith(
                    fontSize: Get.width > 768 ? 26 : 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _getProjectTypeLabel() + ' Application',
                  style: TextStyle(
                    color: projectColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogContent(Color projectColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.project.images.isNotEmpty) ...[
          _buildImageSection(projectColor),
          SizedBox(height: 40),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoSection(
                'Overview',
                widget.project.description,
                Icons.info_outline,
                projectColor,
              ),
            ),
            if (Get.width > 768) ...[
              SizedBox(width: 20),
              _buildQuickLinks(projectColor),
            ],
          ],
        ),
        SizedBox(height: 32),
        if (widget.project.details.isNotEmpty) ...[
          _buildInfoSection(
            'Detailed Description',
            widget.project.details,
            Icons.description,
            projectColor,
          ),
          SizedBox(height: 32),
        ],
        if (widget.project.features.isNotEmpty) ...[
          _buildFeaturesSection(projectColor),
          SizedBox(height: 32),
        ],
        _buildTechnologiesSection(projectColor),
      ],
    );
  }

  Widget _buildQuickLinks(Color projectColor) {
    final isMobile = Get.width < 768;

    if (isMobile) {
      return SizedBox();
    }

    return Column(
      children: [
        if (widget.project.projectType == 'web')
          _buildLinkIconButton(
            icon: Icons.language,
            label: 'Website',
            isActive: widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty,
            color: projectColor,
            onTap: () => _launchUrl(widget.project.liveUrl ?? ''),
          )
        else if (widget.project.projectType == 'mobile') ...[
          _buildLinkIconButton(
            icon: Icons.shop,
            label: 'Play Store',
            isActive: widget.project.playStoreUrl != null && widget.project.playStoreUrl!.isNotEmpty,
            color: Color(0xFF10b981),
            onTap: () => _launchUrl(widget.project.playStoreUrl ?? ''),
          ),
          SizedBox(height: 12),
          _buildLinkIconButton(
            icon: Icons.apple,
            label: 'App Store',
            isActive: widget.project.appStoreUrl != null && widget.project.appStoreUrl!.isNotEmpty,
            color: Color(0xFF3b82f6),
            onTap: () => _launchUrl(widget.project.appStoreUrl ?? ''),
          ),
          SizedBox(height: 12),
          _buildLinkIconButton(
            icon: Icons.android,
            label: 'APK',
            isActive: widget.project.apkUrl != null && widget.project.apkUrl!.isNotEmpty,
            color: AppColors.purple,
            onTap: () => _launchUrl(widget.project.apkUrl ?? ''),
          ),
        ],
        if (widget.project.githubUrl != null && widget.project.githubUrl!.isNotEmpty) ...[
          SizedBox(height: 12),
          _buildLinkIconButton(
            icon: Icons.code,
            label: 'GitHub',
            isActive: true,
            color: Colors.white70,
            onTap: () => _launchUrl(widget.project.githubUrl!),
          ),
        ],
      ],
    );
  }

  Widget _buildLinkIconButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 120,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? color.withOpacity(0.5) : Colors.white24,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? color : Colors.white24,
                size: 24,
              ),
              SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? color : Colors.white24,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(Color projectColor) {
    if (widget.project.images.length == 1) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: projectColor.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: projectColor.withOpacity(0.2),
              blurRadius: 20,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: NetworkImageWithFallback(
            imageUrl: _convertDriveUrl(widget.project.images.first),
            width: double.infinity,
            height: Get.width > 768 ? 450 : 280,
          ),
        ),
      );
    }

    return Column(
      children: widget.project.images.asMap().entries.map((entry) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: projectColor.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: projectColor.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: NetworkImageWithFallback(
              imageUrl: _convertDriveUrl(entry.value),
              width: double.infinity,
              height: Get.width > 768 ? 450 : 280,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: AppTextStyles.headline3.copyWith(
                fontSize: Get.width > 768 ? 24 : 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Text(
            content,
            style: AppTextStyles.body1.copyWith(height: 1.7),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(Color projectColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [projectColor, projectColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.star, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Key Features',
              style: AppTextStyles.headline3.copyWith(
                fontSize: Get.width > 768 ? 24 : 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        ...widget.project.features.asMap().entries.map((entry) {
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: projectColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: projectColor.withOpacity(0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 2),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [projectColor, projectColor.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${entry.key + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    entry.value,
                    style: AppTextStyles.body1.copyWith(height: 1.6),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTechnologiesSection(Color projectColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [projectColor, projectColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.code, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Technologies Used',
              style: AppTextStyles.headline3.copyWith(
                fontSize: Get.width > 768 ? 24 : 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: widget.project.technologies.map<Widget>((tech) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    projectColor.withOpacity(0.2),
                    projectColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: projectColor.withOpacity(0.5), width: 1.5),
              ),
              child: Text(
                tech,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _convertDriveUrl(String url) {
    if (url.contains('drive.google.com')) {
      final fileIdMatch = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(url);
      if (fileIdMatch != null) {
        final fileId = fileIdMatch.group(1);
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      }

      final idMatch = RegExp(r'id=([a-zA-Z0-9_-]+)').firstMatch(url);
      if (idMatch != null) {
        final fileId = idMatch.group(1);
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      }
    }
    return url;
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) {
      Get.snackbar(
        'Not Available',
        'This link is not configured',
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
    } else {
      Get.snackbar(
        'Error',
        'Could not open link',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

class _FloatingActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FloatingActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_FloatingActionButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends State<_FloatingActionButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color,
                      widget.color.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4 + (_glowAnimation.value * 0.4)),
                      blurRadius: 15 + (_glowAnimation.value * 10),
                      spreadRadius: 2 + (_glowAnimation.value * 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}