import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/home_controller.dart';
import '../../../widgets/network_image_with_fallback.dart';
import 'glass_card.dart';

class ProjectsSection extends GetView<HomeController> {
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
          Text(
            'Featured Projects',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Get.width > 768 ? 60 : 40),
          Obx(() {
            if (controller.projects.isEmpty) {
              return Center(
                child: Text(
                  'No projects available',
                  style: AppTextStyles.body1,
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                double childAspectRatio = 0.75;

                if (Get.width < 600) {
                  crossAxisCount = 1;
                  childAspectRatio = 0.95;
                } else if (Get.width < 900) {
                  crossAxisCount = 2;
                  childAspectRatio = 0.8;
                } else if (Get.width < 1200) {
                  crossAxisCount = 2;
                  childAspectRatio = 0.85;
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
                  itemCount: controller.projects.length,
                  itemBuilder: (context, index) {
                    final project = controller.projects[index];
                    return _ProjectCard(project: project);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showProjectDetails(),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            NetworkImageWithFallback(
              imageUrl: project.images.isNotEmpty ? _convertDriveUrl(project.images.first) : null,
              height: Get.width > 768 ? 180 : 150,
              width: double.infinity,
              fallbackIcon: Icons.image,
              fallbackIconSize: 60,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(Get.width > 768 ? 16 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: AppTextStyles.headline3.copyWith(
                        fontSize: Get.width > 768 ? 20 : 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        project.description,
                        style: AppTextStyles.body2.copyWith(
                          fontSize: Get.width > 768 ? 14 : 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildProjectButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectButtons() {
    final buttons = <Widget>[];

    if (project.projectType == 'web' && project.liveUrl != null && project.liveUrl!.isNotEmpty) {
      buttons.add(_buildActionButton(
        icon: Icons.web,
        label: 'Web',
        isActive: true,
        onTap: () => _launchUrl(project.liveUrl!),
      ));
    }

    if (project.projectType == 'mobile') {
      buttons.add(_buildActionButton(
        icon: Icons.shop,
        label: 'Play Store',
        isActive: project.playStoreUrl != null && project.playStoreUrl!.isNotEmpty,
        onTap: () => _launchUrl(project.playStoreUrl ?? ''),
      ));

      buttons.add(_buildActionButton(
        icon: Icons.apple,
        label: 'App Store',
        isActive: project.appStoreUrl != null && project.appStoreUrl!.isNotEmpty,
        onTap: () => _launchUrl(project.appStoreUrl ?? ''),
      ));

      buttons.add(_buildActionButton(
        icon: Icons.android,
        label: 'APK',
        isActive: project.apkUrl != null && project.apkUrl!.isNotEmpty,
        onTap: () => _launchUrl(project.apkUrl ?? ''),
      ));
    }

    if (buttons.isEmpty) {
      return Text(
        'No links available',
        style: TextStyle(color: Colors.white38, fontSize: 12),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: buttons,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width > 768 ? 12 : 8,
          vertical: Get.width > 768 ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.purple.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.purple : Colors.white24,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: Get.width > 768 ? 16 : 14,
              color: isActive ? AppColors.purple : Colors.white38,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: Get.width > 768 ? 12 : 10,
                color: isActive ? Colors.white : Colors.white38,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectDetails() {
    Get.dialog(
      Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: Get.width > 1024 ? 1000 : Get.width * 0.95,
            height: Get.height * 0.92,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: Get.width > 768 ? 0 : 10),
            decoration: BoxDecoration(
              color: Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.glassBackground,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(
                      bottom: BorderSide(color: AppColors.glassBorder),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: AppTextStyles.headline3.copyWith(
                            fontSize: Get.width > 768 ? 24 : 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(Get.width > 768 ? 32 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (project.images.isNotEmpty) _buildImageGallery(),
                        SizedBox(height: 32),
                        _buildSection(
                          'Project Type',
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.purple),
                            ),
                            child: Text(
                              project.projectType == 'web' ? 'Web Application' : 'Mobile Application',
                              style: AppTextStyles.body1.copyWith(color: AppColors.purple),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        _buildSection('Description', Text(project.description, style: AppTextStyles.body1)),
                        SizedBox(height: 24),
                        if (project.details.isNotEmpty) ...[
                          _buildSection('Project Details', Text(project.details, style: AppTextStyles.body1)),
                          SizedBox(height: 24),
                        ],
                        if (project.features.isNotEmpty) ...[
                          _buildSection(
                            'Key Features',
                            Column(
                              children: project.features.map((feature) => Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.cyan.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.check, color: AppColors.cyan, size: 16),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: AppTextStyles.body1,
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                        _buildSection(
                          'Technologies Used',
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: project.technologies.map<Widget>((tech) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.purple.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.purple.withOpacity(0.5)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.code, size: 16, color: AppColors.purple),
                                  SizedBox(width: 8),
                                  Text(tech, style: AppTextStyles.body2),
                                ],
                              ),
                            )).toList(),
                          ),
                        ),
                        SizedBox(height: 32),
                        _buildProjectLinks(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildImageGallery() {
    if (project.images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: NetworkImageWithFallback(
          imageUrl: _convertDriveUrl(project.images.first),
          width: double.infinity,
          height: Get.width > 768 ? 400 : 250,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return Container(
      height: Get.width > 768 ? 400 : 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: project.images.length,
        itemBuilder: (context, index) {
          return Container(
            width: Get.width > 768 ? 600 : Get.width * 0.85,
            margin: EdgeInsets.only(right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: NetworkImageWithFallback(
                imageUrl: _convertDriveUrl(project.images[index]),
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headline3.copyWith(fontSize: Get.width > 768 ? 22 : 18),
        ),
        SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildProjectLinks() {
    final links = <Map<String, dynamic>>[];

    if (project.projectType == 'web') {
      if (project.liveUrl != null && project.liveUrl!.isNotEmpty) {
        links.add({
          'icon': Icons.web,
          'label': 'Visit Website',
          'url': project.liveUrl,
          'color': AppColors.cyan,
        });
      }
    } else {
      if (project.playStoreUrl != null && project.playStoreUrl!.isNotEmpty) {
        links.add({
          'icon': Icons.shop,
          'label': 'Get on Play Store',
          'url': project.playStoreUrl,
          'color': Colors.green,
        });
      }
      if (project.appStoreUrl != null && project.appStoreUrl!.isNotEmpty) {
        links.add({
          'icon': Icons.apple,
          'label': 'Get on App Store',
          'url': project.appStoreUrl,
          'color': Colors.blue,
        });
      }
      if (project.apkUrl != null && project.apkUrl!.isNotEmpty) {
        links.add({
          'icon': Icons.download,
          'label': 'Download APK',
          'url': project.apkUrl,
          'color': AppColors.purple,
        });
      }
    }

    if (project.githubUrl != null && project.githubUrl!.isNotEmpty) {
      links.add({
        'icon': Icons.code,
        'label': 'View Source Code',
        'url': project.githubUrl,
        'color': Colors.white70,
      });
    }

    if (links.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No download or preview links available for this project',
                style: AppTextStyles.body2.copyWith(color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: AppTextStyles.headline3.copyWith(fontSize: Get.width > 768 ? 22 : 18),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: links.map((link) {
            return ElevatedButton.icon(
              onPressed: () => _launchUrl(link['url']),
              icon: Icon(link['icon'], size: 20),
              label: Text(link['label']),
              style: ElevatedButton.styleFrom(
                backgroundColor: (link['color'] as Color).withOpacity(0.15),
                foregroundColor: link['color'],
                side: BorderSide(color: link['color'], width: 1.5),
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width > 768 ? 24 : 16,
                  vertical: Get.width > 768 ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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