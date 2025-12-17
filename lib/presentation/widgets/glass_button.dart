import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double width;
  final double height;

  const GlassButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isPrimary = false,
    this.width = 160,
    this.height = 50,
  }) : super(key: key);

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? LinearGradient(
              colors: AppColors.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: widget.isPrimary ? null : AppColors.glassBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppColors.white.withOpacity(0.5)
                  : AppColors.glassBorder,
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: widget.isPrimary
                    ? AppColors.purple.withOpacity(0.5)
                    : AppColors.white.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Center(
                child: Text(
                  widget.text,
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}