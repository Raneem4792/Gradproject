import 'package:flutter/material.dart';

import 'pilgrim_home_screen.dart';
import 'provider_home_screen.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'provider_history_screen.dart';
import 'provider_manage_meals_screen.dart';
import 'provider_mangae_campaign_screen.dart';

import 'pilgrim_profile_page.dart';
import 'provider_profile_page.dart';
import 'pilgrim_meals_page.dart';

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

      // الصفحة اللي يبدأ منها التطبيق
      initialRoute: ProviderHomeScreen.routeName,

      routes: {
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),

        PilgrimHomeScreen.routeName: (context) => const PilgrimHomeScreen(),
        ProviderHomeScreen.routeName: (context) => const ProviderHomeScreen(),

        ProviderHistoryScreen.routeName: (context) =>
            const ProviderHistoryScreen(),

        ProviderMealManagementScreen.routeName: (context) =>
            const ProviderMealManagementScreen(),

        ProviderCampaignManagementScreen.routeName: (context) =>
            const ProviderCampaignManagementScreen(),

        // صفحات البروفايل
        '/pilgrimProfile': (context) => const PilgrimProfilePage(),
        '/providerProfile': (context) => const ProviderProfilePage(),
        PilgrimMealsPage.routeName: (_) => const PilgrimMealsPage(),
      },
    );
  }
}
