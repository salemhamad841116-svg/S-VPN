import 'package:flutter/material.dart';
import '../models/server_location.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class ServerSelector extends StatelessWidget {
  final ServerLocation selectedServer;
  final bool isEnabled;
  final ValueChanged<ServerLocation> onServerSelected;

  const ServerSelector({
    super.key,
    required this.selectedServer,
    required this.isEnabled,
    required this.onServerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: isEnabled ? 1.0 : 0.55,
      child: GlassContainer(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        backgroundColor: Colors.white.withOpacity(0.04),
        onTap: isEnabled ? () => _showServerPicker(context) : null,
        child: Row(
          children: [
            // Country Flag / Emoji Badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
                border: Border.all(
                  color: AppTheme.glassBorderColor,
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Text(
                  selectedServer.flagEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Server Location Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        selectedServer.country,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (!isEnabled) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.lock_rounded,
                          size: 13,
                          color: AppTheme.textMuted,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${selectedServer.city} • Optimal Route',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Ping Latency Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getPingColor(selectedServer.pingMs).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getPingColor(selectedServer.pingMs).withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getPingColor(selectedServer.pingMs),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${selectedServer.pingMs} ms',
                    style: TextStyle(
                      color: _getPingColor(selectedServer.pingMs),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Chevron Icon
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isEnabled ? AppTheme.textSecondary : AppTheme.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPingColor(int ping) {
    if (ping < 30) return AppTheme.neonEmerald;
    if (ping < 60) return AppTheme.neonCyan;
    return AppTheme.neonAmber;
  }

  void _showServerPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: GlassContainer(
              margin: const EdgeInsets.all(16),
              borderRadius: 28,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              backgroundColor: AppTheme.obsidianElevated.withOpacity(0.92),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Server Location',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Choose a server for highest speed and lowest latency',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Server List
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: ServerLocation.defaultServers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final server = ServerLocation.defaultServers[index];
                        final isCurrent = server.id == selectedServer.id;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              onServerSelected(server);
                              Navigator.of(sheetContext).pop();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? AppTheme.neonCyan.withOpacity(0.08)
                                    : Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isCurrent
                                      ? AppTheme.neonCyan.withOpacity(0.4)
                                      : AppTheme.glassBorderColor,
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    server.flagEmoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          server.country,
                                          style: TextStyle(
                                            color: isCurrent
                                                ? AppTheme.neonCyan
                                                : AppTheme.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.5,
                                          ),
                                        ),
                                        Text(
                                          '${server.city} (${server.ip})',
                                          style: const TextStyle(
                                            color: AppTheme.textMuted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getPingColor(server.pingMs)
                                          .withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${server.pingMs} ms',
                                      style: TextStyle(
                                        color: _getPingColor(server.pingMs),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (isCurrent)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppTheme.neonCyan,
                                      size: 20,
                                    )
                                  else
                                    const Icon(
                                      Icons.radio_button_unchecked_rounded,
                                      color: AppTheme.textMuted,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
