import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/vpn_view_model.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VpnClientApp());
}

class VpnClientApp extends StatelessWidget {
  const VpnClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<VpnViewModel>(
          create: (_) => VpnViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'NeonShield VPN Pro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );
  }
}
