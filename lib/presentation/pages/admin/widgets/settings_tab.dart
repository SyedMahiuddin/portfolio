import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';

class SettingsTab extends GetView<AdminController> {
  @override
  Widget build(BuildContext context) {
    controller.loadCurrentTheme();

    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme Settings',
            style: AppTextStyles.headline2,
          ),
          SizedBox(height: 32),
          _buildThemeStyleSection(),
          SizedBox(height: 40),
          _buildColorCustomization(),
          SizedBox(height: 40),
          _buildPresetThemes(),
          SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildThemeStyleSection() {
    final styles = [
      {
        'id': 'glassmorphism',
        'name': 'Glassmorphism',
        'description': 'Frosted glass effect with blur',
        'icon': Icons.blur_on,
      },
      {
        'id': 'neumorphism',
        'name': 'Neumorphism',
        'description': 'Soft shadows and highlights',
        'icon': Icons.light_mode,
      },
      {
        'id': 'gradient',
        'name': 'Gradient',
        'description': 'Bold gradient backgrounds',
        'icon': Icons.gradient,
      },
      {
        'id': 'minimal',
        'name': 'Minimal',
        'description': 'Clean and simple design',
        'icon': Icons.minimize,
      },
      {
        'id': 'cyberpunk',
        'name': 'Cyberpunk',
        'description': 'Neon and futuristic vibes',
        'icon': Icons.flash_on,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Style',
          style: AppTextStyles.headline3.copyWith(fontSize: 20),
        ),
        SizedBox(height: 16),
        Obx(() => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: styles.map((style) {
            final isSelected = controller.selectedThemeStyle.value == style['id'];
            return _ThemeStyleCard(
              name: style['name'] as String,
              description: style['description'] as String,
              icon: style['icon'] as IconData,
              isSelected: isSelected,
              onTap: () => controller.selectedThemeStyle.value = style['id'] as String,
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget _buildColorCustomization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Customization',
          style: AppTextStyles.headline3.copyWith(fontSize: 20),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2,
          children: [
            _ColorPickerCard(
              label: 'Primary Color',
              color: controller.primaryColor,
              onColorChanged: (color) => controller.primaryColor.value = color,
            ),
            _ColorPickerCard(
              label: 'Secondary Color',
              color: controller.secondaryColor,
              onColorChanged: (color) => controller.secondaryColor.value = color,
            ),
            _ColorPickerCard(
              label: 'Accent Color',
              color: controller.accentColor,
              onColorChanged: (color) => controller.accentColor.value = color,
            ),
            _ColorPickerCard(
              label: 'Background',
              color: controller.backgroundColor,
              onColorChanged: (color) => controller.backgroundColor.value = color,
            ),
            _ColorPickerCard(
              label: 'Surface',
              color: controller.surfaceColor,
              onColorChanged: (color) => controller.surfaceColor.value = color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetThemes() {
    final presets = [
      {
        'id': 'purple_dream',
        'name': 'Purple Dream',
        'colors': [Color(0xFFB24BF3), Color(0xFF00E5FF), Color(0xFFFF006B)],
      },
      {
        'id': 'ocean_breeze',
        'name': 'Ocean Breeze',
        'colors': [Color(0xFF0EA5E9), Color(0xFF06B6D4), Color(0xFF3B82F6)],
      },
      {
        'id': 'sunset_glow',
        'name': 'Sunset Glow',
        'colors': [Color(0xFFF97316), Color(0xFFFBBF24), Color(0xFFEF4444)],
      },
      {
        'id': 'forest_mint',
        'name': 'Forest Mint',
        'colors': [Color(0xFF10B981), Color(0xFF34D399), Color(0xFF059669)],
      },
      {
        'id': 'cyberpunk',
        'name': 'Cyberpunk',
        'colors': [Color(0xFFFF00FF), Color(0xFF00FFFF), Color(0xFFFFFF00)],
      },
      {
        'id': 'elegant_dark',
        'name': 'Elegant Dark',
        'colors': [Color(0xFF8B5CF6), Color(0xFFA78BFA), Color(0xFFC4B5FD)],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preset Themes',
          style: AppTextStyles.headline3.copyWith(fontSize: 20),
        ),
        SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: presets.map((preset) {
            return _PresetThemeCard(
              name: preset['name'] as String,
              colors: preset['colors'] as List<Color>,
              onTap: () => controller.applyPresetTheme(preset['id'] as String),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Obx(() => ElevatedButton.icon(
          onPressed: controller.isLoading.value ? null : controller.saveThemeSettings,
          icon: controller.isLoading.value
              ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Icon(Icons.save),
          label: Text(controller.isLoading.value ? 'Saving...' : 'Save Theme'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            minimumSize: Size(160, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )),
        SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: controller.resetToDefault,
          icon: Icon(Icons.refresh),
          label: Text('Reset to Default'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white70,
            side: BorderSide(color: Colors.white30),
            minimumSize: Size(160, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeStyleCard extends StatefulWidget {
  final String name;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeStyleCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ThemeStyleCard> createState() => _ThemeStyleCardState();
}

class _ThemeStyleCardState extends State<_ThemeStyleCard> {
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
          width: 240,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.purple.withOpacity(0.2)
                : AppColors.glassBackground,
            borderRadius: BorderRadius.circular(16),
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
                blurRadius: 20,
                spreadRadius: 2,
              )
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: widget.isSelected
                          ? LinearGradient(colors: [AppColors.purple, AppColors.cyan])
                          : null,
                      color: widget.isSelected ? null : Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (widget.isSelected) ...[
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColors.purple, size: 24),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Text(
                widget.name,
                style: AppTextStyles.headline3.copyWith(fontSize: 18),
              ),
              SizedBox(height: 4),
              Text(
                widget.description,
                style: AppTextStyles.body2.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorPickerCard extends StatelessWidget {
  final String label;
  final Rx<Color> color;
  final Function(Color) onColorChanged;

  const _ColorPickerCard({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
      onTap: () => _showColorPicker(context),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.value,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.value.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body1.copyWith(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '#${color.value.value.toRadixString(16).substring(2).toUpperCase()}',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: Colors.white60, size: 20),
          ],
        ),
      ),
    ));
  }

  void _showColorPicker(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF0D1117),
        title: Text(label, style: AppTextStyles.headline3.copyWith(fontSize: 20)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color.value,
            onColorChanged: onColorChanged,
            pickerAreaHeightPercent: 0.8,
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
            labelTypes: [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.purple),
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _PresetThemeCard extends StatefulWidget {
  final String name;
  final List<Color> colors;
  final VoidCallback onTap;

  const _PresetThemeCard({
    required this.name,
    required this.colors,
    required this.onTap,
  });

  @override
  State<_PresetThemeCard> createState() => _PresetThemeCardState();
}

class _PresetThemeCardState extends State<_PresetThemeCard> {
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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: widget.colors.first.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}