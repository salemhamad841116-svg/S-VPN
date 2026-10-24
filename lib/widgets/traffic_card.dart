import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class TrafficCard extends StatelessWidget {
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isConnected;

  const TrafficCard({
    super.key,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: 20,
      backgroundColor: Colors.white.withOpacity(0.04),
      child: Row(
        children: [
          // Download Speed Stat
          Expanded(
            child: _buildMetricItem(
              label: 'DOWNLOAD',
              value: isConnected
                  ? '${downloadSpeed.toStringAsFixed(1)} MB/s'
                  : '0.0 MB/s',
              icon: Icons.arrow_downward_rounded,
              iconColor: isConnected ? AppTheme.neonCyan : AppTheme.textMuted,
              glowColor: isConnected ? AppTheme.neonCyan : Colors.transparent,
            ),
          ),

          // Vertical divider
          Container(
            width: 1.2,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.02),
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.02),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Upload Speed Stat
          Expanded(
            child: _buildMetricItem(
              label: 'UPLOAD',
              value: isConnected
                  ? '${uploadSpeed.toStringAsFixed(1)} MB/s'
                  : '0.0 MB/s',
              icon: Icons.arrow_upward_rounded,
              iconColor: isConnected ? AppTheme.neonPurple : AppTheme.textMuted,
              glowColor: isConnected ? AppTheme.neonPurple : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color glowColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Glowing Icon Badge
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.12),
            border: Border.all(
              color: iconColor.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: isConnected
                ? [
                    BoxShadow(
                      color: glowColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),

        const SizedBox(width: 12),

        // Text labels
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: isConnected ? AppTheme.textPrimary : AppTheme.textMuted,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
