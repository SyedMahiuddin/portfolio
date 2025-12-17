import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class PortfolioNavbar extends StatelessWidget {
  final Function(int) onNavigate;

  const PortfolioNavbar({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: Get.width > 1024 ? 80 : 20),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SM',
            style: AppTextStyles.headline3.copyWith(
              fontSize: Get.width > 768 ? 28 : 24,
            ),
          ),
          if (Get.width > 900)
            Row(
              children: [
                _NavItem(title: 'Home', onTap: () => onNavigate(0)),
                SizedBox(width: 32),
                _NavItem(title: 'Skills', onTap: () => onNavigate(1)),
                SizedBox(width: 32),
                _NavItem(title: 'Projects', onTap: () => onNavigate(2)),
                SizedBox(width: 32),
                _NavItem(title: 'Experience', onTap: () => onNavigate(3)),
                SizedBox(width: 32),
                _NavItem(title: 'Contact', onTap: () => onNavigate(4)),
              ],
            )
          else
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _showMobileMenu(context),
            ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF0D1117),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.home, color: AppColors.purple),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                onNavigate(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.code, color: AppColors.purple),
              title: Text('Skills', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                onNavigate(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.work, color: AppColors.purple),
              title: Text('Projects', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                onNavigate(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.timeline, color: AppColors.purple),
              title: Text('Experience', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                onNavigate(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: AppColors.purple),
              title: Text('Contact', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                onNavigate(4);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isHovered ? AppColors.purple : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.title,
            style: AppTextStyles.body1.copyWith(
              color: _isHovered ? AppColors.purple : Colors.white70,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}