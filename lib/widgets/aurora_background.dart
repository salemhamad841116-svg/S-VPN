import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuroraBackground extends StatefulWidget {
  final Widget child;

  const AuroraBackground({
    super.key,
    required this.child,
  });

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark obsidian layer
        Container(
          color: AppTheme.obsidianVoid,
        ),

        // Animated organic Aurora blobs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final double value = _controller.value;
            final double sinVal = sin(value * 2 * pi);
            final double cosVal = cos(value * 2 * pi);

            return Stack(
              children: [
                // Aurora Top-Left (Electric Cyan / Teal)
                Positioned(
                  top: -80 + (sinVal * 40),
                  left: -60 + (cosVal * 30),
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.neonCyan.withOpacity(0.18),
                          AppTheme.auroraTeal.withOpacity(0.08),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Aurora Center-Right (Electric Purple / Violet)
                Positioned(
                  top: 240 + (cosVal * 50),
                  right: -80 + (sinVal * 30),
                  child: Container(
                    width: 360,
                    height: 360,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.neonPurple.withOpacity(0.16),
                          AppTheme.auroraIndigo.withOpacity(0.07),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ),

                // Aurora Bottom-Center (Emerald / Cyan glow)
                Positioned(
                  bottom: -100 + (sinVal * 30),
                  left: 40 + (cosVal * 40),
                  child: Container(
                    width: 380,
                    height: 380,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.neonEmerald.withOpacity(0.14),
                          AppTheme.auroraTeal.withOpacity(0.06),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Subtle mesh dot overlay for sleek cyber finish
        Positioned.fill(
          child: CustomPaint(
            painter: _CyberGridPainter(),
          ),
        ),

        // Foreground content
        widget.child,
      ],
    );
  }
}

class _CyberGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..strokeWidth = 1.0;

    const double spacing = 48.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
