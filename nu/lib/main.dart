import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'pages/home_page.dart';
import 'pages/pilgrim_home_screen.dart';
import 'pages/provider_home_screen.dart';
import 'pages/signup_page.dart';
import 'pages/login_page.dart';
import 'pages/provider_history_screen.dart';
import 'pages/provider_manage_meals_screen.dart';
import 'pages/provider_mangae_campaign_screen.dart';
import 'pages/forgot_password_page.dart';
import 'pages/pilgrim_profile_page.dart';
import 'pages/provider_profile_page.dart';
import 'pages/pilgrim_meals_page.dart';
import 'pages/admin_manage_accounts_page.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/admin_monitor_orders_page.dart';
import 'pages/admin_notifications_page.dart';
import 'pages/admin_profile_page.dart';
import 'pages/admin_alerts_page.dart';
void main() {
  runApp(const NusuqApp());
}

class NusuqApp extends StatefulWidget {
  const NusuqApp({super.key});

  static _NusuqAppState of(BuildContext context) {
    return context.findAncestorStateOfType<_NusuqAppState>()!;
  }

  @override
  State<NusuqApp> createState() => _NusuqAppState();
}

class _NusuqAppState extends State<NusuqApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NUSUQ',

      locale: _locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      initialRoute: HomePage.routeName,

      routes: {
        HomePage.routeName: (context) => const HomePage(),
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

        ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
        AdminManageAccountsPage.routeName: (context) => const AdminManageAccountsPage(),
        AdminDashboardPage.routeName: (context) => const AdminDashboardPage(),
        AdminMonitorOrdersPage.routeName: (context) => const AdminMonitorOrdersPage(),
        AdminNotificationsPage.routeName: (context) => const AdminNotificationsPage(),
        AdminProfilePage.routeName: (context) => const AdminProfilePage(),
        AdminAlertsPage.routeName: (_) => const AdminAlertsPage(),

      },
    );
  }
}