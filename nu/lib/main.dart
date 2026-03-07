import 'package:flutter/material.dart';
import 'pilgrim_home_screen.dart';
import 'provider_home_screen.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'provider_history_screen.dart';
import 'provider_manage_meals_screen.dart';
import 'provider_mangae_campaign_screen.dart';

void main() {
  runApp(const NusuqApp());
}

class NusuqApp extends StatelessWidget {
  const NusuqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUSUQ',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0D4C4A),
      ),

      // يبدأ التطبيق بصفحة التسجيل
      initialRoute: ProviderHomeScreen.routeName,

      routes: {
        SignUpScreen.routeName: (_) => const SignUpScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        PilgrimHomeScreen.routeName: (_) => const PilgrimHomeScreen(),
        ProviderHomeScreen.routeName: (_) => const ProviderHomeScreen(),
        ProviderHistoryScreen.routeName: (_) => const ProviderHistoryScreen(),
        ProviderMealManagementScreen.routeName: (_) =>
            const ProviderMealManagementScreen(),
        ProviderCampaignManagementScreen.routeName: (_) =>
            const ProviderCampaignManagementScreen(),
      },
    );
  }
}
