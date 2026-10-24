import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class TimerDisplay extends StatelessWidget {
  final String formattedTime;
  final bool isConnected;

  const TimerDisplay({
    super.key,
    required this.formattedTime,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderRadius: 16,
      backgroundColor: Colors.white.withOpacity(0.035),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: isConnected ? AppTheme.neonEmerald : AppTheme.textMuted,
          ),
          const SizedBox(width: 10),
          Text(
            'DURATION',
            style: TextStyle(
              color: isConnected ? AppTheme.neonEmerald : AppTheme.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 14,
            color: Colors.white.withOpacity(0.12),
          ),
          const SizedBox(width: 12),
          Text(
            formattedTime,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
              color: isConnected ? AppTheme.textPrimary : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
