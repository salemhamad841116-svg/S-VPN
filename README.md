# S-VPN (NeonShield VPN Pro)

A modern, full-stack Flutter VPN Client UI targeting macOS and Web (`flutter run -d web-server`). Built with a dark Glassmorphism aesthetic (Obsidian Dark / Neon Glass style with animated Aurora backdrops).

---

## Features

- **Dark Glassmorphic UI**: Obsidian Dark base theme with frosted glass containers (`BackdropFilter`), glowing specular borders, and animated dynamic Aurora radial gradients.
- **Main Connection Screen**:
  - **Server Location Dropdown**: Select between preconfigured locations (United States, Germany, UAE, Japan, Singapore, UK) with real-time ping latency indicators. Disabled while connecting or connected.
  - **Central Status Shield**: Large central glowing Shield (Red for Disconnected, Green for Connected) and a Blue circular progress indicator during the 2-second connection handshake.
  - **Connection Timer**: Digital monospace session timer (`00:00`) that increments only while connected.
  - **Traffic Simulation**: Real-time Upload and Download speeds in MB/s with directional arrows fluctuating every second while connected.
  - **Primary Action Toggle**: Bottom Connect / Disconnect button with neon glow feedback.
- **Settings & Configuration Screen**:
  - **Protocol Selector**: Choose between `VLESS Reality`, `WireGuard`, and `sing-box`.
  - **Port Configuration**: Customizable port (default: `443`) with validation.
  - **Custom DNS**: Upstream DNS field with quick-fill presets (`1.1.1.1`, `8.8.8.8`, `9.9.9.9`, `94.140.14.14`).
  - **Security Toggles**: Integrated Kill Switch and Split Tunneling controls.
  - **Save Action**: Dedicated save action with visual confirmation snackbars.
- **Service & MethodChannel Integration**:
  - `VpnService` with `MethodChannel('com.vpn_client.pro/vpn_control')` for native DPI bypass routing.
  - Web fallback handling that catches and swallows `MissingPluginException` gracefully so the UI never freezes in the connecting state.

---

## Getting Started

### Prerequisites
- Flutter 3.19+ / Dart 3.3+

### Run Locally

1. **Run as native macOS Desktop application:**
   ```bash
   flutter run -d macos
   ```

2. **Run in Web Browser (Development mode):**
   ```bash
   flutter run -d web-server --web-renderer html --web-port=8080
   ```

3. **Build Web Release:**
   ```bash
   flutter build web --web-renderer html --release
   ```

4. **Run Automated Tests:**
   ```bash
   flutter test
   ```
