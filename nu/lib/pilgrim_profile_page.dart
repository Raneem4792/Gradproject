import 'package:flutter/material.dart';
import 'nusuq_colors.dart';

class PilgrimProfilePage extends StatelessWidget {
  const PilgrimProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NusuqColors.appBg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Transform.translate(
                    offset: const Offset(0, -18),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildQuickStatsCards(),
                          const SizedBox(height: 14),
                          _buildPersonalInfo(),
                          const SizedBox(height: 14),
                          _buildDietaryNeeds(),
                          const SizedBox(height: 14),
                          _buildMyStats(),
                          const SizedBox(height: 14),
                          _buildSettings(),
                          const SizedBox(height: 14),
                          _buildLogoutBtn(),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  // ════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NusuqColors.deepForest,
            NusuqColors.midGreen,
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 34),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _editBtn(),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _avatar('HA', NusuqColors.midGreen, NusuqColors.brightGreen),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                            children: [
                              TextSpan(
                                text: 'Hamida ',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Akhtar',
                                style: TextStyle(color: NusuqColors.gold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.white70,
                              size: 15,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Makkah Al-Mukarramah',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _VerifiedBadge(text: 'Hajj 1447H'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  // QUICK STATS
  // ════════════════════════════════════════
  Widget _buildQuickStatsCards() {
    return Row(
      children: const [
        Expanded(
          child: _MiniStatCard(
            value: '18',
            label: 'Meals Ordered',
            valueColor: NusuqColors.brightGreen,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            value: '4.9★',
            label: 'Avg Rating',
            valueColor: NusuqColors.gold,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _MiniStatCard(
            value: '6',
            label: 'Days Active',
            valueColor: NusuqColors.midGreen,
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════
  // CARDS
  // ════════════════════════════════════════
  Widget _buildPersonalInfo() => _card(
        icon: Icons.person_outline_rounded,
        iconBg: NusuqColors.mintSurface,
        title: 'Personal Information',
        action: 'Edit',
        child: Column(
          children: [
            _row('Full Name', 'Hamida Akhtar'),
            _row('Nationality', 'Pakistani', leadingEmoji: '🇵🇰'),
            _row('Passport No.', 'AK-7291043'),
            _row('Phone', '+92 300 1234567'),
            _row(
              'Campaign',
              'Al-Nour Group',
              vc: NusuqColors.midGreen,
            ),
          ],
        ),
      );

  Widget _buildDietaryNeeds() => _card(
        icon: Icons.restaurant_menu_rounded,
        iconBg: NusuqColors.mintSurface,
        title: 'Dietary & Health Needs',
        action: 'Edit',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Health Condition', 'Type 2 Diabetes'),
            _row('Allergies', 'Nuts, Gluten', leadingEmoji: '⚠️'),
            _row(
              'Meal Preference',
              'Low Carb',
              vc: NusuqColors.midGreen,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _tag('Vegan', on: true),
                  _tag('Gluten-Free', on: true),
                  _tag('Diabetic', on: true),
                  _tag('High Protein', on: false),
                  _tag('Heart Diet', on: false),
                  _tag('Nut Allergy', on: true),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildMyStats() => _card(
        icon: Icons.bar_chart_rounded,
        iconBg: NusuqColors.goldSurface,
        title: 'My Statistics',
        child: Column(
          children: [
            _row('Total Meals', '18 meals'),
            _row('Meals Rated', '15 ratings'),
            _row(
              'Avg Satisfaction',
              '4.9 / 5.0 ★',
              vc: NusuqColors.gold,
            ),
            _row(
              'Favourite Meal',
              'Grilled Chicken Salad',
              leadingEmoji: '🥗',
            ),
          ],
        ),
      );

  Widget _buildSettings() => _card(
        icon: Icons.settings_outlined,
        iconBg: const Color(0xFFF3F4F6),
        title: 'Settings & Notifications',
        child: Column(
          children: [
            _toggleRow(
              icon: Icons.notifications_none_rounded,
              bg: NusuqColors.mintSurface,
              label: 'Meal Reminders',
              sub: 'Notify before each meal',
              on: true,
            ),
            _toggleRow(
              icon: Icons.auto_awesome_outlined,
              bg: NusuqColors.mintSurface,
              label: 'AI Suggestions',
              sub: 'Daily smart meal picks',
              on: true,
            ),
            _arrowRow(
              icon: Icons.language_rounded,
              bg: const Color(0xFFF3F4F6),
              label: 'Language',
              val: 'English',
            ),
            _arrowRow(
              icon: Icons.lock_outline_rounded,
              bg: const Color(0xFFF3F4F6),
              label: 'Privacy & Data',
            ),
          ],
        ),
      );

  Widget _buildLogoutBtn() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F4),
        border: Border.all(color: const Color(0xFFFFD9D9)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFE53935),
                  size: 19,
                ),
                SizedBox(width: 8),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  // BOTTOM NAV
  // ════════════════════════════════════════
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEDF3EF)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, 'Home', false),
          _navItem(Icons.explore_outlined, 'Explore', false),
          _navFab(Icons.restaurant_menu_rounded),
          _navItem(Icons.favorite_border_rounded, 'Saved', false),
          _navItem(Icons.person_rounded, 'Profile', true),
        ],
      ),
    );
  }

  // ════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════
  Widget _editBtn() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          border: Border.all(color: Colors.white.withOpacity(0.18)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.edit_outlined, color: Colors.white70, size: 14),
            SizedBox(width: 6),
            Text(
              'Edit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  Widget _avatar(String initials, Color c1, Color c2) => Container(
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [c1, c2]),
          border: Border.all(color: Colors.white24, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  Widget _card({
    required IconData icon,
    required Color iconBg,
    required String title,
    String? action,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: NusuqColors.border),
        boxShadow: [
          BoxShadow(
            color: NusuqColors.deepForest.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: NusuqColors.border),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 18,
                    color: NusuqColors.midGreen,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: NusuqColors.textDark,
                    ),
                  ),
                ),
                if (action != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: NusuqColors.mintSurface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      action,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: NusuqColors.midGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _row(
    String k,
    String v, {
    Color? vc,
    String? leadingEmoji,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEF5F1)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                k,
                style: const TextStyle(
                  fontSize: 12.2,
                  color: NusuqColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leadingEmoji != null) ...[
                    Text(leadingEmoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      v,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: vc ?? NusuqColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _tag(String label, {required bool on}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: on ? NusuqColors.mintSurface : const Color(0xFFF5F5F5),
          border: Border.all(
            color: on ? NusuqColors.midGreen : const Color(0xFFEAEAEA),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.2,
            fontWeight: FontWeight.w700,
            color: on ? NusuqColors.midGreen : const Color(0xFFB5B5B5),
          ),
        ),
      );

  Widget _toggleRow({
    required IconData icon,
    required Color bg,
    required String label,
    required String sub,
    required bool on,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEF5F1)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 19, color: NusuqColors.midGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13.2,
                      fontWeight: FontWeight.w700,
                      color: NusuqColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: NusuqColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 38,
              height: 22,
              decoration: BoxDecoration(
                color: on ? NusuqColors.midGreen : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Align(
                alignment:
                    on ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _arrowRow({
    required IconData icon,
    required Color bg,
    required String label,
    String? val,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEF5F1)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 19, color: NusuqColors.textDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13.2,
                  fontWeight: FontWeight.w700,
                  color: NusuqColors.textDark,
                ),
              ),
            ),
            if (val != null)
              Text(
                val,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: NusuqColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFBFBFBF),
              size: 20,
            ),
          ],
        ),
      );

  Widget _navItem(IconData icon, String label, bool active) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active ? NusuqColors.mintSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: active ? NusuqColors.midGreen : const Color(0xFFB7B7B7),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.2,
                fontWeight: FontWeight.w700,
                color:
                    active ? NusuqColors.midGreen : const Color(0xFFB7B7B7),
              ),
            ),
          ],
        ),
      );

  Widget _navFab(IconData icon) => Container(
        width: 58,
        height: 58,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          gradient: NusuqColors.buttonGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: NusuqColors.midGreen.withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 26),
      );
}

class _MiniStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _MiniStatCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NusuqColors.border),
        boxShadow: [
          BoxShadow(
            color: NusuqColors.deepForest.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.3,
              fontWeight: FontWeight.w600,
              color: NusuqColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  final String text;

  const _VerifiedBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: NusuqColors.gold.withOpacity(0.14),
        border: Border.all(color: NusuqColors.gold.withOpacity(0.35)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: NusuqColors.gold,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}