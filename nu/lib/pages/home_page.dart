import 'package:flutter/material.dart';

import '../main.dart';
import 'login_page.dart';
import 'signup_page.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color accent = Color(0xFF16A085);
  static const Color softBg = Color(0xFFF8FAFA);

  bool _isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  Future<void> _changeLanguage(BuildContext context) async {
    final currentLocale = Localizations.localeOf(context).languageCode;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        final isAr = _isArabic(context);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    isAr ? 'اختاري اللغة' : 'Choose Language',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _LanguageTile(
                  title: 'العربية',
                  selected: currentLocale == 'ar',
                  onTap: () => Navigator.pop(context, 'ar'),
                ),
                const SizedBox(height: 8),
                _LanguageTile(
                  title: 'English',
                  selected: currentLocale == 'en',
                  onTap: () => Navigator.pop(context, 'en'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && context.mounted) {
      NusuqApp.of(context).setLocale(Locale(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = _isArabic(context);

    return Scaffold(
      backgroundColor: primaryDark,
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftPatternBackground()),

          Positioned(
            top: -90,
            right: -70,
            child: _GlowCircle(size: 220, opacity: 0.11),
          ),
          Positioned(
            bottom: -120,
            left: -90,
            child: _GlowCircle(size: 270, opacity: 0.10),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: IconButton(
                          onPressed: () => _changeLanguage(context),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.14),
                            foregroundColor: Colors.white,
                            fixedSize: const Size(48, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.18),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.language_rounded),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.18),
                              Colors.white.withOpacity(0.08),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.24),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.20),
                              blurRadius: 24,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.restaurant_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'NUSUQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        isAr
                            ? 'منصة ذكية لخدمة الحجاج ومقدمي الوجبات'
                            : 'Smart platform for serving pilgrims and meal providers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        decoration: BoxDecoration(
                          color: softBg,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 34,
                              offset: const Offset(0, 18),
                              color: Colors.black.withOpacity(0.20),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 5,
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              isAr ? 'مرحبًا بك في نسق' : 'Welcome to Nusuq',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1F2937),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              isAr
                                  ? 'ابدئي رحلتك بسهولة للوصول إلى الوجبات، الطلبات، والتوصيات الذكية المناسبة.'
                                  : 'Start your journey easily with meals, orders, and smart recommendations.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.black.withOpacity(0.58),
                                fontWeight: FontWeight.w600,
                                height: 1.55,
                              ),
                            ),

                            const SizedBox(height: 22),

                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: (constraints.maxWidth - 24) / 3,
                                      child: _FeatureCard(
                                        icon: Icons.restaurant_menu_rounded,
                                        title: isAr ? 'وجبات' : 'Meals',
                                        subtitle: isAr
                                            ? 'مناسبة لك'
                                            : 'For you',
                                      ),
                                    ),
                                    SizedBox(
                                      width: (constraints.maxWidth - 24) / 3,
                                      child: _FeatureCard(
                                        icon: Icons.health_and_safety_outlined,
                                        title: isAr ? 'صحة' : 'Health',
                                        subtitle: isAr
                                            ? 'ملفك الصحي'
                                            : 'Your profile',
                                      ),
                                    ),
                                    SizedBox(
                                      width: (constraints.maxWidth - 24) / 3,
                                      child: _FeatureCard(
                                        icon: Icons.auto_awesome_rounded,
                                        title: isAr ? 'ذكاء' : 'AI',
                                        subtitle: isAr
                                            ? 'توصيات'
                                            : 'Smart picks',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginScreen.routeName,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accent,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.login_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 9),
                                    Text(
                                      isAr ? 'تسجيل الدخول' : 'Log In',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 13),

                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    SignUpScreen.routeName,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primary,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: primary.withOpacity(0.22),
                                    width: 1.4,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.person_add_alt_1_rounded,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 9),
                                    Text(
                                      isAr
                                          ? 'إنشاء حساب جديد'
                                          : 'Create Account',
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        '© 2026 NUSUQ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        isAr
                            ? 'نظام متكامل لخدمة الحجاج'
                            : 'Integrated system for serving pilgrims',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8E7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5F2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: primary, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.50),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: selected ? const Color(0xFFEAF5F2) : const Color(0xFFF7F8F8),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Color(0xFF1F2937),
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: primary)
          : null,
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _SoftPatternBackground extends StatelessWidget {
  const _SoftPatternBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _SoftPatternPainter());
  }
}

class _SoftPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..style = PaintingStyle.fill;

    const double spacing = 78;
    const double shapeSize = 25;

    for (double y = -20; y < size.height + spacing; y += spacing) {
      for (double x = -20; x < size.width + spacing; x += spacing) {
        final path = Path();

        path.moveTo(x, y + shapeSize / 2);
        path.lineTo(x + shapeSize / 2, y);
        path.lineTo(x + shapeSize, y + shapeSize / 2);
        path.lineTo(x + shapeSize / 2, y + shapeSize);
        path.close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
