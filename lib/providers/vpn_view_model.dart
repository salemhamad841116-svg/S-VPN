import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/server_location.dart';
import '../models/vpn_config.dart';
import '../services/vpn_service.dart';

enum VpnState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

class VpnViewModel extends ChangeNotifier {
  final VpnService _vpnService;

  VpnState _state = VpnState.disconnected;
  ServerLocation _selectedServer = ServerLocation.defaultServers.first;
  VpnConfig _config = VpnConfig.defaultConfig();
  Duration _duration = Duration.zero;
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;

  Timer? _trafficTimer;
  final Random _random = Random();

  VpnViewModel({VpnService? vpnService})
      : _vpnService = vpnService ?? VpnService();

  // Getters
  VpnState get state => _state;
  ServerLocation get selectedServer => _selectedServer;
  VpnConfig get config => _config;
  Duration get duration => _duration;
  double get downloadSpeed => _downloadSpeed;
  double get uploadSpeed => _uploadSpeed;

  bool get isDisconnected => _state == VpnState.disconnected;
  bool get isConnecting => _state == VpnState.connecting;
  bool get isConnected => _state == VpnState.connected;
  bool get isDisconnecting => _state == VpnState.disconnecting;

  /// The server selector must be disabled while connecting or connected
  bool get canChangeServer => _state == VpnState.disconnected;

  /// Formatted timer string: mm:ss (or hh:mm:ss if over an hour)
  String get formattedTimer {
    final int hours = _duration.inHours;
    final int minutes = _duration.inMinutes.remainder(60);
    final int seconds = _duration.inSeconds.remainder(60);

    final String minStr = minutes.toString().padLeft(2, '0');
    final String secStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final String hrStr = hours.toString().padLeft(2, '0');
      return '$hrStr:$minStr:$secStr';
    }
    return '$minStr:$secStr';
  }

  /// Select a new server location (only permitted when disconnected)
  void setServer(ServerLocation server) {
    if (!canChangeServer) return;
    _selectedServer = server;
    notifyListeners();
  }

  /// Update the active VPN configuration payload
  void updateConfig(VpnConfig newConfig) {
    _config = newConfig;
    notifyListeners();
  }

  /// Toggles between connect and disconnect
  Future<void> toggleConnection() async {
    if (isConnected) {
      await disconnect();
    } else if (isDisconnected) {
      await connect();
    }
  }

  /// Initiates VPN connection
  Future<void> connect() async {
    if (_state != VpnState.disconnected) return;

    _state = VpnState.connecting;
    _duration = Duration.zero;
    _downloadSpeed = 0.0;
    _uploadSpeed = 0.0;
    notifyListeners();

    try {
      final bool success = await _vpnService.connect(
        config: _config,
        server: _selectedServer,
      );

      if (success) {
        _state = VpnState.connected;
        _startTrafficAndTimer();
      } else {
        _state = VpnState.disconnected;
      }
    } catch (e) {
      debugPrint('[VpnViewModel] Connection error handled: $e');
      _state = VpnState.disconnected;
    } finally {
      notifyListeners();
    }
  }

  /// Disconnects the active VPN session
  Future<void> disconnect() async {
    if (_state != VpnState.connected && _state != VpnState.connecting) return;

    _stopTrafficAndTimer();
    _state = VpnState.disconnecting;
    notifyListeners();

    try {
      await _vpnService.disconnect();
    } catch (e) {
      debugPrint('[VpnViewModel] Disconnect error handled: $e');
    } finally {
      _state = VpnState.disconnected;
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
      _duration = Duration.zero;
      notifyListeners();
    }
  }

  void _startTrafficAndTimer() {
    _trafficTimer?.cancel();
    _duration = Duration.zero;

    // Initial speed burst
    _downloadSpeed = _generateDownloadSpeed();
    _uploadSpeed = _generateUploadSpeed();

    _trafficTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state != VpnState.connected) {
        timer.cancel();
        return;
      }

      _duration = _duration + const Duration(seconds: 1);
      _downloadSpeed = _generateDownloadSpeed();
      _uploadSpeed = _generateUploadSpeed();
      notifyListeners();
    });
  }

  void _stopTrafficAndTimer() {
    _trafficTimer?.cancel();
    _trafficTimer = null;
  }

  double _generateDownloadSpeed() {
    // Fluctuating download speed between 14.5 MB/s and 52.8 MB/s
    final double base = 25.0 + (_random.nextDouble() * 22.0);
    final double jitter = (_random.nextDouble() - 0.5) * 4.0;
    return double.parse((base + jitter).clamp(5.0, 95.0).toStringAsFixed(1));
  }

  double _generateUploadSpeed() {
    // Fluctuating upload speed between 3.2 MB/s and 18.6 MB/s
    final double base = 6.0 + (_random.nextDouble() * 9.0);
    final double jitter = (_random.nextDouble() - 0.5) * 2.0;
    return double.parse((base + jitter).clamp(1.0, 35.0).toStringAsFixed(1));
  }

  @override
  void dispose() {
    _stopTrafficAndTimer();
    super.dispose();
  }
}
