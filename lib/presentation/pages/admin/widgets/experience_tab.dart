import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';
import '../../../../data/models/experience_model.dart';

class ExperienceTab extends GetView<AdminController> {
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
                'Work Experience',
                style: AppTextStyles.headline2,
              ),
              ElevatedButton.icon(
                onPressed: () => _showExperienceDialog(),
                icon: Icon(Icons.add),
                label: Text('Add Experience'),
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
          child: Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 32),
            itemCount: controller.experiences.length,
            itemBuilder: (context, index) {
              final exp = controller.experiences[index];
              return _buildExperienceCard(exp);
            },
          )),
        ),
      ],
    );
  }

  Widget _buildExperienceCard(ExperienceModel exp) {
    return Container(
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
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.gradientColors),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business, color: Colors.white, size: 35),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.position,
                  style: AppTextStyles.headline3.copyWith(fontSize: 22),
                ),
                SizedBox(height: 8),
                Text(
                  exp.company,
                  style: AppTextStyles.body1.copyWith(color: AppColors.purple),
                ),
                SizedBox(height: 12),
                Text(
                  exp.description,
                  style: AppTextStyles.body2,
                ),
                SizedBox(height: 12),
                Text(
                  '${exp.startDate} - ${exp.endDate ?? 'Present'}',
                  style: AppTextStyles.body2.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          Column(
            children: [
              if (exp.isCurrently)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cyan),
                  ),
                  child: Text('Currently', style: TextStyle(color: AppColors.cyan, fontSize: 12)),
                ),
              SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _showExperienceDialog(exp: exp),
                    icon: Icon(Icons.edit, color: AppColors.cyan),
                  ),
                  IconButton(
                    onPressed: () => _deleteExperience(exp.id),
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

  void _showExperienceDialog({ExperienceModel? exp}) {
    final isEdit = exp != null;

    if (isEdit) {
      controller.editExperience(exp);
    } else {
      controller.clearExperienceForm();
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
                  isEdit ? 'Edit Experience' : 'Add New Experience',
                  style: AppTextStyles.headline3,
                ),
                SizedBox(height: 24),
                _buildTextField(
                  label: 'Company',
                  controller: controller.expCompanyController,
                  icon: Icons.business,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Position',
                  controller: controller.expPositionController,
                  icon: Icons.work,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Description',
                  controller: controller.expDescController,
                  icon: Icons.description,
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'Start Date (e.g., Jan 2020)',
                        controller: controller.expStartDateController,
                        icon: Icons.calendar_today,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => controller.expIsCurrently.value
                          ? Container(
                        height: 74,
                        alignment: Alignment.center,
                        child: Text('Present', style: AppTextStyles.body1),
                      )
                          : _buildTextField(
                        label: 'End Date (e.g., Dec 2022)',
                        controller: controller.expEndDateController,
                        icon: Icons.calendar_today,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Obx(() => CheckboxListTile(
                  title: Text('Currently Working', style: AppTextStyles.body1),
                  value: controller.expIsCurrently.value,
                  onChanged: (value) => controller.expIsCurrently.value = value ?? false,
                  activeColor: AppColors.purple,
                  checkColor: Colors.white,
                )),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        controller.clearExperienceForm();
                        Get.back();
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.white70)),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (isEdit) {
                          controller.updateExperience(exp);
                        } else {
                          controller.addExperience();
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

  void _deleteExperience(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF0D1117),
        title: Text('Delete Experience', style: AppTextStyles.headline3.copyWith(fontSize: 20)),
        content: Text('Are you sure you want to delete this experience?', style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteExperience(id);
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