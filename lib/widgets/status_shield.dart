import 'package:flutter/material.dart';
import '../providers/vpn_view_model.dart';
import '../theme/app_theme.dart';

class StatusShield extends StatefulWidget {
  final VpnState state;
  final String ipAddress;

  const StatusShield({
    super.key,
    required this.state,
    required this.ipAddress,
  });

  @override
  State<StatusShield> createState() => _StatusShieldState();
}

class _StatusShieldState extends State<StatusShield>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isConnected = widget.state == VpnState.connected;
    final bool isConnecting = widget.state == VpnState.connecting;
    final bool isDisconnecting = widget.state == VpnState.disconnecting;

    final Color statusColor = isConnected
        ? AppTheme.neonEmerald
        : (isConnecting || isDisconnecting
            ? AppTheme.neonCyan
            : AppTheme.neonCrimson);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Central Shield / Progress Orb
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final double glowSpread = isConnected
                ? 18.0 + (_pulseAnimation.value * 12.0)
                : (isConnecting
                    ? 14.0 + (_pulseAnimation.value * 8.0)
                    : 10.0 + (_pulseAnimation.value * 6.0));

            return Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    statusColor.withOpacity(0.18),
                    statusColor.withOpacity(0.04),
                    Colors.transparent,
                  ],
                  stops: const [0.35, 0.75, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.25),
                    blurRadius: glowSpread,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 126,
                  height: 126,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.obsidianElevated,
                    border: Border.all(
                      color: statusColor.withOpacity(0.4),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: isConnecting || isDisconnecting
                          ? _buildConnectingIndicator()
                          : _buildShieldIcon(isConnected),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 18),

        // Status pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: statusColor.withOpacity(0.35),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.8),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(),
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // IP Address / Protection subtitle
        Text(
          isConnected ? 'IP: ${widget.ipAddress}' : 'Traffic Unencrypted',
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildShieldIcon(bool isConnected) {
    final Color iconColor =
        isConnected ? AppTheme.neonEmerald : AppTheme.neonCrimson;

    return Icon(
      isConnected ? Icons.shield_rounded : Icons.shield_outlined,
      key: ValueKey<bool>(isConnected),
      size: 64,
      color: iconColor,
    );
  }

  Widget _buildConnectingIndicator() {
    return const SizedBox(
      key: ValueKey<String>('connecting_spinner'),
      width: 52,
      height: 52,
      child: CircularProgressIndicator(
        strokeWidth: 3.5,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.neonCyan),
        backgroundColor: Color(0x2200E5FF),
      ),
    );
  }

  String _getStatusText() {
    switch (widget.state) {
      case VpnState.connected:
        return 'CONNECTED';
      case VpnState.connecting:
        return 'CONNECTING...';
      case VpnState.disconnecting:
        return 'DISCONNECTING...';
      case VpnState.disconnected:
        return 'DISCONNECTED';
    }
  }
}
