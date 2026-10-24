class VpnConfig {
  static const List<String> availableProtocols = [
    'VLESS Reality',
    'WireGuard',
    'sing-box',
  ];

  final String protocol;
  final int port;
  final String dns;
  final bool killSwitch;
  final bool splitTunneling;

  const VpnConfig({
    required this.protocol,
    required this.port,
    required this.dns,
    this.killSwitch = true,
    this.splitTunneling = false,
  });

  factory VpnConfig.defaultConfig() {
    return const VpnConfig(
      protocol: 'VLESS Reality',
      port: 443,
      dns: '1.1.1.1',
      killSwitch: true,
      splitTunneling: false,
    );
  }

  VpnConfig copyWith({
    String? protocol,
    int? port,
    String? dns,
    bool? killSwitch,
    bool? splitTunneling,
  }) {
    return VpnConfig(
      protocol: protocol ?? this.protocol,
      port: port ?? this.port,
      dns: dns ?? this.dns,
      killSwitch: killSwitch ?? this.killSwitch,
      splitTunneling: splitTunneling ?? this.splitTunneling,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'protocol': protocol,
      'port': port,
      'dns': dns,
      'killSwitch': killSwitch,
      'splitTunneling': splitTunneling,
    };
  }

  factory VpnConfig.fromMap(Map<String, dynamic> map) {
    return VpnConfig(
      protocol: map['protocol'] as String? ?? 'VLESS Reality',
      port: map['port'] as int? ?? 443,
      dns: map['dns'] as String? ?? '1.1.1.1',
      killSwitch: map['killSwitch'] as bool? ?? true,
      splitTunneling: map['splitTunneling'] as bool? ?? false,
    );
  }
}
