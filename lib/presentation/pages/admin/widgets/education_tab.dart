import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../../../data/models/education_model.dart';

class EducationTab extends GetView<AdminController> {
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
                'Education',
                style: AppTextStyles.headline2,
              ),
              ElevatedButton.icon(
                onPressed: () => _showEducationDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Education'),
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
          child: Obx(() => ReorderableListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 32),
            itemCount: controller.educations.length,
            onReorder: controller.reorderEducations,
            itemBuilder: (context, index) {
              final edu = controller.educations[index];
              return _buildEducationCard(edu, index, key: ValueKey(edu.id));
            },
          )),
        ),
      ],
    );
  }

  Widget _buildEducationCard(EducationModel edu, int index, {required Key key}) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.drag_indicator, color: Colors.white38),
          SizedBox(width: 16),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.cyan, AppColors.purple]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.school, color: Colors.white, size: 35),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu.degree,
                  style: AppTextStyles.headline3.copyWith(fontSize: 20),
                ),
                SizedBox(height: 4),
                Text(
                  edu.field,
                  style: AppTextStyles.body1.copyWith(color: AppColors.cyan),
                ),
                SizedBox(height: 8),
                Text(
                  edu.institution,
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                Text(
                  edu.description,
                  style: AppTextStyles.body2,
                ),
                SizedBox(height: 12),
                Text(
                  '${edu.startDate} - ${edu.endDate ?? 'Present'}',
                  style: AppTextStyles.body2.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (edu.isCurrently)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.purple),
                  ),
                  child: Text('Currently', style: TextStyle(color: AppColors.purple, fontSize: 12)),
                ),
              SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showEducationDialog(edu: edu),
                    icon: Icon(Icons.edit, color: AppColors.cyan),
                  ),
                  IconButton(
                    onPressed: () => _deleteEducation(edu.id),
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEducationDialog({EducationModel? edu}) {
    final isEdit = edu != null;

    if (isEdit) {
      controller.editEducation(edu);
    } else {
      controller.clearEducationForm();
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Edit Education' : 'Add New Education',
                  style: AppTextStyles.headline3,
                ),
                SizedBox(height: 24),
                _buildTextField(
                  label: 'Institution/University',
                  controller: controller.eduInstitutionController,
                  icon: Icons.school,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Degree',
                  controller: controller.eduDegreeController,
                  icon: Icons.workspace_premium,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Field of Study',
                  controller: controller.eduFieldController,
                  icon: Icons.menu_book,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Description',
                  controller: controller.eduDescController,
                  icon: Icons.description,
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Start Date (e.g., Jan 2020)',
                        controller: controller.eduStartDateController,
                        icon: Icons.calendar_today,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => controller.eduIsCurrently.value
                          ? Container(
                        height: 74,
                        alignment: Alignment.center,
                        child: Text('Present', style: AppTextStyles.body1),
                      )
                          : _buildTextField(
                        label: 'End Date (e.g., Dec 2022)',
                        controller: controller.eduEndDateController,
                        icon: Icons.calendar_today,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() => CheckboxListTile(
                  title: Text('Currently Studying', style: AppTextStyles.body1),
                  value: controller.eduIsCurrently.value,
                  onChanged: (value) => controller.eduIsCurrently.value = value ?? false,
                  activeColor: AppColors.purple,
                  checkColor: Colors.white,
                )),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.clearEducationForm();
                        Get.back();
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.white70)),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (isEdit) {
                          controller.updateEducation(edu);
                        } else {
                          controller.addEducation();
                        }
                      },
                      child: Text(isEdit ? 'Update' : 'Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  void _deleteEducation(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF0D1117),
        title: Text('Delete Education', style: AppTextStyles.headline3.copyWith(fontSize: 20)),
        content: Text('Are you sure you want to delete this education?', style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteEducation(id);
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