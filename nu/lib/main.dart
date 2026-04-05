import 'package:flutter/material.dart';

import 'pages/pilgrim_home_screen.dart';
import 'pages/provider_home_screen.dart';
import 'pages/signup_page.dart';
import 'pages/login_page.dart';
import 'pages/provider_history_screen.dart';
import 'pages/provider_manage_meals_screen.dart';
import 'pages/provider_mangae_campaign_screen.dart';

import 'pages/pilgrim_profile_page.dart';
import 'pages/provider_profile_page.dart';
import 'pages/pilgrim_meals_page.dart';

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
      initialRoute: SignUpScreen.routeName,

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

       
        '/pilgrimProfile': (context) => const PilgrimProfilePage(),
        '/providerProfile': (context) => const ProviderProfilePage(),
        PilgrimMealsPage.routeName: (_) => const PilgrimMealsPage(),
      },
    );
  }
}
