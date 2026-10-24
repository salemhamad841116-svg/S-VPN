import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vpn_client_pro/main.dart';

void main() {
  testWidgets('VPN Client UI initial state and settings navigation test',
      (WidgetTester tester) async {
    // Configure standard desktop / macOS window size for test
    tester.view.physicalSize = const Size(1024, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const VpnClientApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Title and AppBar
    expect(find.text('NEON SHIELD'), findsOneWidget);

    // Verify default server is shown
    expect(find.text('United States'), findsOneWidget);

    // Verify initial disconnected state and shield
    expect(find.text('DISCONNECTED'), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    // Verify timer display shows initial duration
    expect(find.text('00:00'), findsOneWidget);

    // Verify traffic indicators
    expect(find.text('DOWNLOAD'), findsOneWidget);
    expect(find.text('UPLOAD'), findsOneWidget);
    expect(find.text('0.0 MB/s'), findsNWidgets(2));

    // Verify Connect button
    expect(find.text('CONNECT'), findsOneWidget);

    // Verify Navigation to Settings Screen via gear icon
    final settingsButton = find.byTooltip('VPN Configuration');
    expect(settingsButton, findsOneWidget);

    await tester.tap(settingsButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Verify Settings Screen title and elements
    expect(find.text('VPN Configuration'), findsOneWidget);
    expect(find.text('Routing Protocol'), findsOneWidget);
    expect(find.text('Port Configuration'), findsOneWidget);
    expect(find.text('Custom DNS'), findsOneWidget);
    expect(find.text('VLESS Reality'), findsOneWidget);

    // Scroll down to reveal Save button
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pump(const Duration(milliseconds: 300));

    final saveButton = find.text('SAVE CONFIGURATION');
    expect(saveButton, findsOneWidget);

    // Tap Save and verify navigation back to MainScreen
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('NEON SHIELD'), findsOneWidget);
  });
}
