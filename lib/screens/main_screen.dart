import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_view_model.dart';
import '../theme/app_theme.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/server_selector.dart';
import '../widgets/status_shield.dart';
import '../widgets/timer_display.dart';
import '../widgets/traffic_card.dart';
import 'settings_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnViewModel>(
      builder: (context, vpn, _) {
        return Scaffold(
          backgroundColor: AppTheme.obsidianVoid,
          appBar: _buildAppBar(context, vpn),
          body: AuroraBackground(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Server Selector Dropdown
                        ServerSelector(
                          selectedServer: vpn.selectedServer,
                          isEnabled: vpn.canChangeServer,
                          onServerSelected: (server) {
                            vpn.setServer(server);
                          },
                        ),

                        const SizedBox(height: 28),

                        // Large Central Shield / Progress Indicator
                        StatusShield(
                          state: vpn.state,
                          ipAddress: vpn.isConnected
                              ? vpn.selectedServer.ip
                              : '0.0.0.0',
                        ),

                        const SizedBox(height: 24),

                        // Digital Connection Timer (00:00)
                        TimerDisplay(
                          formattedTime: vpn.formattedTimer,
                          isConnected: vpn.isConnected,
                        ),

                        const SizedBox(height: 20),

                        // Real-Time Traffic Simulation Card
                        TrafficCard(
                          downloadSpeed: vpn.downloadSpeed,
                          uploadSpeed: vpn.uploadSpeed,
                          isConnected: vpn.isConnected,
                        ),

                        const SizedBox(height: 20),

                        // Active Protocol & Security Badge
                        _buildProtocolBadge(vpn),

                        const SizedBox(height: 32),

                        // Primary Connect / Disconnect Toggle Button
                        _buildPrimaryActionButton(vpn),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, VpnViewModel vpn) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.neonCyan, AppTheme.neonPurple],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonCyan.withOpacity(0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.security_rounded,
              size: 16,
              color: AppTheme.obsidianVoid,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'NEON SHIELD',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
      actions: [
        // Sleek gear icon leading to Settings Screen
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: AppTheme.glassBorderColor,
                  width: 1.0,
                ),
              ),
              child: const Icon(
                Icons.settings_outlined,
                size: 20,
                color: AppTheme.textPrimary,
              ),
            ),
            tooltip: 'VPN Configuration',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolBadge(VpnViewModel vpn) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 14,
      backgroundColor: Colors.white.withOpacity(0.025),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tune_rounded,
            size: 14,
            color: vpn.isConnected ? AppTheme.neonCyan : AppTheme.textMuted,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '${vpn.config.protocol} • Port ${vpn.config.port} • DNS ${vpn.config.dns}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionButton(VpnViewModel vpn) {
    final bool isConnected = vpn.isConnected;
    final bool isConnecting = vpn.isConnecting;
    final bool isDisconnecting = vpn.isDisconnecting;
    final bool isBusy = isConnecting || isDisconnecting;

    final Gradient buttonGradient = isConnected
        ? AppTheme.disconnectedGradient
        : (isBusy
            ? AppTheme.connectingGradient
            : const LinearGradient(
                colors: [
                  AppTheme.neonCyan,
                  Color(0xFF00B0FF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ));

    final Color shadowColor = isConnected
        ? AppTheme.neonCrimson.withOpacity(0.4)
        : (isBusy
            ? AppTheme.neonCyan.withOpacity(0.3)
            : AppTheme.neonCyan.withOpacity(0.45));

    final String buttonLabel = isConnecting
        ? 'CONNECTING...'
        : (isDisconnecting
            ? 'DISCONNECTING...'
            : (isConnected ? 'DISCONNECT' : 'CONNECT'));

    final IconData buttonIcon = isConnected
        ? Icons.power_settings_new_rounded
        : (isBusy ? Icons.sync_rounded : Icons.lock_open_rounded);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: buttonGradient,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 22,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isBusy ? null : () => vpn.toggleConnection(),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isBusy)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.obsidianVoid,
                      ),
                    ),
                  )
                else
                  Icon(
                    buttonIcon,
                    color: AppTheme.obsidianVoid,
                    size: 22,
                  ),
                const SizedBox(width: 10),
                Text(
                  buttonLabel,
                  style: const TextStyle(
                    color: AppTheme.obsidianVoid,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
