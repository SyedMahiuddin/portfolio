import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBlob extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;

  const AnimatedBlob({
    Key? key,
    required this.color,
    this.size = 300,
    this.duration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: BlobPainter(
            color: widget.color,
            animation: _controller.value,
          ),
        );
      },
    );
  }
}

class BlobPainter extends CustomPainter {
  final Color color;
  final double animation;

  BlobPainter({required this.color, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 50);

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (var i = 0; i < 360; i += 1) {
      final angle = i * pi / 180;
      final r = radius +
          sin(animation * 2 * pi + i * 0.02) * radius * 0.3 +
          cos(animation * 2 * pi + i * 0.03) * radius * 0.2;
      final x = centerX + r * cos(angle);
      final y = centerY + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}