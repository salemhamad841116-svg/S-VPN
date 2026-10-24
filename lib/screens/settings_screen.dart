import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vpn_config.dart';
import '../providers/vpn_view_model.dart';
import '../theme/app_theme.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _selectedProtocol;
  late TextEditingController _portController;
  late TextEditingController _dnsController;
  late bool _killSwitch;
  late bool _splitTunneling;

  @override
  void initState() {
    super.initState();
    final config = context.read<VpnViewModel>().config;
    _selectedProtocol = config.protocol;
    _portController = TextEditingController(text: config.port.toString());
    _dnsController = TextEditingController(text: config.dns);
    _killSwitch = config.killSwitch;
    _splitTunneling = config.splitTunneling;
  }

  @override
  void dispose() {
    _portController.dispose();
    _dnsController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int parsedPort = int.tryParse(_portController.text.trim()) ?? 443;
    final String parsedDns = _dnsController.text.trim();

    final updatedConfig = VpnConfig(
      protocol: _selectedProtocol,
      port: parsedPort,
      dns: parsedDns.isEmpty ? '1.1.1.1' : parsedDns,
      killSwitch: _killSwitch,
      splitTunneling: _splitTunneling,
    );

    context.read<VpnViewModel>().updateConfig(updatedConfig);

    // Show visual confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        content: GlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: AppTheme.obsidianElevated.withOpacity(0.95),
          customBorder: Border.all(
            color: AppTheme.neonEmerald.withOpacity(0.5),
            width: 1.2,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.neonEmerald,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Settings saved successfully! Active: $_selectedProtocol',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(milliseconds: 2200),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidianVoid,
      appBar: AppBar(
        title: const Text('VPN Configuration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedProtocol = 'VLESS Reality';
                _portController.text = '443';
                _dnsController.text = '1.1.1.1';
                _killSwitch = true;
                _splitTunneling = false;
              });
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: AppTheme.neonCyan,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  children: [
                    // Protocol Section
                    _buildSectionHeader(
                      title: 'Routing Protocol',
                      subtitle: 'Select cryptographic transport and obfuscation engine',
                      icon: Icons.alt_route_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildProtocolDropdown(),

                    const SizedBox(height: 24),

                    // Port Configuration Section
                    _buildSectionHeader(
                      title: 'Port Configuration',
                      subtitle: 'Specify destination port (Standard TLS is 443)',
                      icon: Icons.tag_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildPortField(),

                    const SizedBox(height: 24),

                    // Custom DNS Section
                    _buildSectionHeader(
                      title: 'Custom DNS',
                      subtitle: 'Secure upstream DNS resolvers for leak protection',
                      icon: Icons.dns_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildDnsField(),
                    const SizedBox(height: 10),
                    _buildDnsPresets(),

                    const SizedBox(height: 24),

                    // Security Toggles
                    _buildSectionHeader(
                      title: 'Security & Tunneling',
                      subtitle: 'Kernel-level protection policies',
                      icon: Icons.security_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildSecurityToggles(),

                    const SizedBox(height: 36),

                    // Distinct Save Action Button
                    _buildSaveButton(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.neonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.neonCyan.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme.neonCyan,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProtocolDropdown() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      borderRadius: 18,
      backgroundColor: Colors.white.withOpacity(0.04),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedProtocol,
          isExpanded: true,
          dropdownColor: AppTheme.obsidianElevated,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppTheme.neonCyan,
          ),
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
          items: VpnConfig.availableProtocols.map((protocol) {
            return DropdownMenuItem<String>(
              value: protocol,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getProtocolColor(protocol).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getProtocolColor(protocol).withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      _getProtocolTag(protocol),
                      style: TextStyle(
                        color: _getProtocolColor(protocol),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(protocol),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedProtocol = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Color _getProtocolColor(String protocol) {
    switch (protocol) {
      case 'VLESS Reality':
        return AppTheme.neonCyan;
      case 'WireGuard':
        return AppTheme.neonEmerald;
      case 'sing-box':
        return AppTheme.neonPurple;
      default:
        return AppTheme.neonBlue;
    }
  }

  String _getProtocolTag(String protocol) {
    switch (protocol) {
      case 'VLESS Reality':
        return 'XTLS';
      case 'WireGuard':
        return 'UDP';
      case 'sing-box':
        return 'CORE';
      default:
        return 'VPN';
    }
  }

  Widget _buildPortField() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 18,
      backgroundColor: Colors.white.withOpacity(0.04),
      child: TextFormField(
        controller: _portController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.transparent,
          filled: false,
          contentPadding: EdgeInsets.zero,
          hintText: '443',
          prefixIcon: Icon(
            Icons.electrical_services_rounded,
            color: AppTheme.textMuted,
            size: 20,
          ),
          suffixText: 'TCP/UDP',
          suffixStyle: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a valid port';
          }
          final port = int.tryParse(value.trim());
          if (port == null || port < 1 || port > 65535) {
            return 'Port must be between 1 and 65535';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDnsField() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 18,
      backgroundColor: Colors.white.withOpacity(0.04),
      child: TextFormField(
        controller: _dnsController,
        keyboardType: TextInputType.url,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.transparent,
          filled: false,
          contentPadding: EdgeInsets.zero,
          hintText: '1.1.1.1, 8.8.8.8',
          prefixIcon: Icon(
            Icons.shield_outlined,
            color: AppTheme.textMuted,
            size: 20,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter at least one DNS address';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDnsPresets() {
    final presets = [
      {'name': 'Cloudflare', 'dns': '1.1.1.1'},
      {'name': 'Google', 'dns': '8.8.8.8'},
      {'name': 'Quad9', 'dns': '9.9.9.9'},
      {'name': 'AdGuard', 'dns': '94.140.14.14'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((preset) {
        final isSelected = _dnsController.text.contains(preset['dns']!);
        return ActionChip(
          backgroundColor: isSelected
              ? AppTheme.neonCyan.withOpacity(0.16)
              : Colors.white.withOpacity(0.04),
          side: BorderSide(
            color: isSelected
                ? AppTheme.neonCyan.withOpacity(0.5)
                : AppTheme.glassBorderColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          label: Text(
            '${preset['name']} (${preset['dns']})',
            style: TextStyle(
              color: isSelected ? AppTheme.neonCyan : AppTheme.textSecondary,
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          onPressed: () {
            setState(() {
              _dnsController.text = preset['dns']!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSecurityToggles() {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 18,
      backgroundColor: Colors.white.withOpacity(0.04),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Kill Switch',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Blocks all internet traffic if VPN drops unexpectedly',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            activeColor: AppTheme.neonCyan,
            value: _killSwitch,
            onChanged: (val) {
              setState(() {
                _killSwitch = val;
              });
            },
          ),
          Divider(
            color: Colors.white.withOpacity(0.06),
            height: 1,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Split Tunneling',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Exclude local subnet & trusted LAN devices',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            activeColor: AppTheme.neonCyan,
            value: _splitTunneling,
            onChanged: (val) {
              setState(() {
                _splitTunneling = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            AppTheme.neonCyan,
            Color(0xFF0091EA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonCyan.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _saveSettings,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.save_rounded,
                  color: AppTheme.obsidianVoid,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'SAVE CONFIGURATION',
                  style: TextStyle(
                    color: AppTheme.obsidianVoid,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
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
