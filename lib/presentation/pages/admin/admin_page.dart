import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio_web/presentation/pages/admin/widgets/education_tab.dart';
import 'package:portfolio_web/presentation/pages/admin/widgets/message_tab.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../controllers/admin_controller.dart';
import 'widgets/admin_sidebar.dart';
import 'widgets/profile_tab.dart';
import 'widgets/projects_tab.dart';
import 'widgets/experience_tab.dart';

class AdminLoginDialog extends StatefulWidget {
  @override
  State<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<AdminLoginDialog> {
  final _emailController = TextEditingController(text: 'admin@portfolio.com');
  final _passwordController = TextEditingController();
  final _isLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    _isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      Get.back();
      Get.toNamed('/admin');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Invalid credentials',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 60,
                color: AppColors.purple,
              ),
              SizedBox(height: 16),
              Text(
                'Admin Login',
                style: AppTextStyles.headline3,
              ),
              SizedBox(height: 24),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white60),
                  prefixIcon: Icon(Icons.email, color: AppColors.purple),
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
                    borderSide: BorderSide(color: AppColors.purple),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white60),
                  prefixIcon: Icon(Icons.lock, color: AppColors.purple),
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
                    borderSide: BorderSide(color: AppColors.purple),
                  ),
                ),
                onSubmitted: (_) => _login(),
              ),
              SizedBox(height: 24),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading.value ? null : () => Get.back(),
                    child: Text('Cancel', style: TextStyle(color: Colors.white70)),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading.value ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading.value
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text('Login'),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminPage extends GetView<AdminController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              switch (controller.selectedTab.value) {
                case 0:
                  return ProfileTab();
                case 1:
                  return ProjectsTab();
                case 2:
                  return ExperienceTab();
                case 3:
                  return MessagesTab();
                case 4:
                  return EducationTab();
                default:
                  return ProfileTab();
              }
            }),
          ),
        ],
      ),
    );
  }
}