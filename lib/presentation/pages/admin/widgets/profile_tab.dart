import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../../widgets/network_image_with_fallback.dart';

class ProfileTab extends GetView<AdminController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Settings',
            style: AppTextStyles.headline2,
          ),
          SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildFormFields()),
                    SizedBox(width: 32),
                    Container(width: 300, child: _buildImageSection()),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildImageSection(),
                    SizedBox(height: 32),
                    _buildFormFields(),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 32),
          Obx(() => ElevatedButton.icon(
            onPressed: controller.isLoading.value ? null : controller.updateProfile,
            icon: controller.isLoading.value
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(Icons.save),
            label: Text(controller.isLoading.value ? 'Saving...' : 'Save Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              minimumSize: Size(200, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(label: 'Name', controller: controller.nameController, icon: Icons.person),
        SizedBox(height: 20),
        _buildTextField(label: 'Role', controller: controller.roleController, icon: Icons.work),
        SizedBox(height: 20),
        _buildTextField(label: 'Bio', controller: controller.bioController, icon: Icons.description, maxLines: 5),
        SizedBox(height: 20),
        _buildTextField(label: 'Location', controller: controller.locationController, icon: Icons.location_on),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Years Experience',
                controller: controller.yearsExpController,
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildTextField(
                label: 'Projects Completed',
                controller: controller.projectsCompletedController,
                icon: Icons.check_circle,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildTextField(label: 'Phone', controller: controller.phoneController, icon: Icons.phone),
        SizedBox(height: 20),
        _buildTextField(label: 'Email', controller: controller.emailController, icon: Icons.email),
        SizedBox(height: 20),
        _buildTextField(label: 'LinkedIn URL', controller: controller.linkedinController, icon: Icons.link),
        SizedBox(height: 20),
        _buildTextField(label: 'GitHub URL', controller: controller.githubController, icon: Icons.code),
        SizedBox(height: 20),
        _buildTextField(label: 'CV URL', controller: controller.cvUrlController, icon: Icons.file_present),
        SizedBox(height: 20),
        _buildTextField(label: 'Hire Me URL', controller: controller.hireMeUrlController, icon: Icons.link),
        SizedBox(height: 32),
        _buildSkillsManagement(),
      ],
    );
  }
  Widget _buildSkillsManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technical Skills',
          style: AppTextStyles.headline3.copyWith(fontSize: 20),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.skillCategoryController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter skill category (e.g., Mobile Development)',
                  hintStyle: TextStyle(color: Colors.white60),
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
            ),
            SizedBox(width: 12),
            ElevatedButton(
              onPressed: controller.addSkillCategory,
              child: Text('Add Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purple,
                minimumSize: Size(120, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Obx(() => controller.technicalSkills.isEmpty
            ? Text('No skill categories added yet', style: TextStyle(color: Colors.white60))
            : Column(
          children: controller.technicalSkills.entries.map((entry) {
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: AppTextStyles.headline3.copyWith(fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () => controller.removeSkillCategory(entry.key),
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: ValueKey(entry.key),
                          onChanged: (value) {
                            controller.skillItemController.text = value;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Add skill',
                            hintStyle: TextStyle(color: Colors.white60),
                            filled: true,
                            fillColor: AppColors.glassBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.glassBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.glassBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.cyan, width: 2),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              controller.addSkillToCategory(entry.key);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => controller.addSkillToCategory(entry.key),
                        child: Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cyan,
                          minimumSize: Size(60, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value.asMap().entries.map((skill) {
                      return Chip(
                        label: Text(skill.value),
                        deleteIcon: Icon(Icons.close, size: 16),
                        onDeleted: () => controller.removeSkillFromCategory(entry.key, skill.key),
                        backgroundColor: AppColors.purple.withOpacity(0.2),
                        deleteIconColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
  Widget _buildImageSection() {
    return Column(
      children: [
        Text(
          'Profile Image',
          style: AppTextStyles.headline3.copyWith(fontSize: 20),
        ),
        SizedBox(height: 20),
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: NetworkImageWithFallback(
              imageUrl: controller.imageUrlController.text,
              width: 250,
              height: 250,
              fallbackIcon: Icons.person,
              fallbackIconSize: 100,
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildTextField(
          label: 'Image URL',
          controller: controller.imageUrlController,
          icon: Icons.link,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
}