import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../../widgets/network_image_with_fallback.dart';
import '../../../../data/models/project_model.dart';

class ProjectsTab extends GetView<AdminController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projects',
                style: AppTextStyles.headline2,
              ),
              ElevatedButton.icon(
                onPressed: () => _showProjectDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Project'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() => GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 32),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.projects.length,
            itemBuilder: (context, index) {
              final project = controller.projects[index];
              return _buildProjectCard(project);
            },
          )),
        ),
      ],
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageWithFallback(
            imageUrl: project.images.isNotEmpty ? project.images.first : null,
            height: 150,
            width: double.infinity,
            fallbackIcon: Icons.image,
            fallbackIconSize: 60,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      project.projectType.toUpperCase(),
                      style: TextStyle(fontSize: 10, color: AppColors.cyan, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    project.title,
                    style: AppTextStyles.headline3.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      project.description,
                      style: AppTextStyles.body2.copyWith(fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.glassBorder, height: 1),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _showProjectDialog(project: project),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: 16, color: AppColors.cyan),
                        SizedBox(width: 4),
                        Text('Edit', style: TextStyle(color: AppColors.cyan)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.glassBorder),
              Expanded(
                child: InkWell(
                  onTap: () => _deleteProject(project.id),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 4),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProjectDialog({ProjectModel? project}) {
    final isEdit = project != null;

    if (isEdit) {
      controller.editProject(project);
    } else {
      controller.clearProjectForm();
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 900,
          height: Get.height * 0.9,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Edit Project' : 'Add New Project',
                    style: AppTextStyles.headline3,
                  ),
                  IconButton(
                    onPressed: () {
                      controller.clearProjectForm();
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Project Type', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 12),
                      Obx(() => Row(
                        children: [
                          Expanded(
                            child: _buildTypeSelector('Mobile', 'mobile'),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTypeSelector('Web', 'web'),
                          ),
                        ],
                      )),
                      SizedBox(height: 20),
                      _buildTextField(
                        label: 'Project Title',
                        controller: controller.projectTitleController,
                        icon: Icons.title,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Short Description (For card preview)',
                        controller: controller.projectDescController,
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'Detailed Project Information',
                        controller: controller.projectDetailsController,
                        icon: Icons.info,
                        maxLines: 5,
                      ),
                      SizedBox(height: 20),
                      Text('Key Features', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.featureInputController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter a key feature',
                                hintStyle: TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: AppColors.glassBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.glassBorder),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: controller.addFeature,
                            child: Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.cyan,
                              minimumSize: Size(80, 48),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Obx(() => controller.projectFeatures.isNotEmpty
                          ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.projectFeatures.asMap().entries.map((entry) {
                          return Chip(
                            label: Text(entry.value),
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () => controller.removeFeature(entry.key),
                            backgroundColor: AppColors.cyan.withOpacity(0.2),
                            deleteIconColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      )
                          : SizedBox()),
                      SizedBox(height: 20),
                      Text('Technologies', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.techInputController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter technology',
                                hintStyle: TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: AppColors.glassBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.glassBorder),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: controller.addTechnology,
                            child: Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              minimumSize: Size(80, 48),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Obx(() => controller.projectTechs.isNotEmpty
                          ? Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.projectTechs.asMap().entries.map((entry) {
                          return Chip(
                            label: Text(entry.value),
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () => controller.removeTechnology(entry.key),
                            backgroundColor: AppColors.purple.withOpacity(0.2),
                            deleteIconColor: Colors.white,
                            labelStyle: TextStyle(color: Colors.white),
                          );
                        }).toList(),
                      )
                          : SizedBox()),
                      SizedBox(height: 20),
                      Text('Project Images (URLs)', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.projectImageUrlController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Paste image URL (Drive, Imgur, etc.)',
                                hintStyle: TextStyle(color: Colors.white60),
                                filled: true,
                                fillColor: AppColors.glassBackground,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.glassBorder),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: controller.addProjectImageUrl,
                            child: Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              minimumSize: Size(80, 48),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Obx(() => controller.projectImages.isNotEmpty
                          ? Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.projectImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 12),
                              child: Stack(
                                children: [
                                  NetworkImageWithFallback(
                                    imageUrl: controller.projectImages[index],
                                    width: 120,
                                    height: 120,
                                    fallbackIcon: Icons.image,
                                    fallbackIconSize: 40,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: InkWell(
                                      onTap: () => controller.removeProjectImage(index),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.close, size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                          : SizedBox()),
                      SizedBox(height: 20),
                      Obx(() {
                        if (controller.selectedProjectType.value == 'web') {
                          return _buildTextField(
                            label: 'Live Website URL',
                            controller: controller.projectLiveUrlController,
                            icon: Icons.web,
                          );
                        } else {
                          return Column(
                            children: [
                              _buildTextField(
                                label: 'Play Store URL (Optional)',
                                controller: controller.projectPlayStoreController,
                                icon: Icons.shop,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'App Store URL (Optional)',
                                controller: controller.projectAppStoreController,
                                icon: Icons.apple,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'APK Download URL (Optional)',
                                controller: controller.projectApkUrlController,
                                icon: Icons.android,
                              ),
                            ],
                          );
                        }
                      }),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: 'GitHub Repository URL (Optional)',
                        controller: controller.projectGithubUrlController,
                        icon: Icons.code,
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.clearProjectForm();
                              Get.back();
                            },
                            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
                          ),
                          SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () {
                              if (isEdit) {
                                controller.updateProject(project);
                              } else {
                                controller.addProject();
                              }
                            },
                            child: Text(isEdit ? 'Update Project' : 'Add Project'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector(String label, String value) {
    final isSelected = controller.selectedProjectType.value == value;

    return InkWell(
      onTap: () => controller.selectedProjectType.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple.withOpacity(0.2) : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.glassBorder,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'mobile' ? Icons.smartphone : Icons.web,
              color: isSelected ? AppColors.purple : Colors.white60,
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.purple : Colors.white60,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.purple),
            filled: true,
            fillColor: AppColors.glassBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.purple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteProject(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF0D1117),
        title: Text('Delete Project', style: AppTextStyles.headline3.copyWith(fontSize: 20)),
        content: Text('Are you sure you want to delete this project?', style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteProject(id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}