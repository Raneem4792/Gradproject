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
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildPersonalInfo(),
                        const SizedBox(height: 14),
                        _buildDietaryNeeds(),
                        const SizedBox(height: 14),
                        _buildMyStats(),
                        const SizedBox(height: 14),
                        _buildSettings(),
                        const SizedBox(height: 14),
                        _buildLogoutBtn(),
                        const SizedBox(height: 10),
                      ],
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
      color: NusuqColors.deepForest,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Profile',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  _editBtn(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _avatar('HA', NusuqColors.midGreen, NusuqColors.brightGreen),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(text: 'Hamida ', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'Akhtar',  style: TextStyle(color: NusuqColors.gold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('📍 Makkah Al-Mukarramah',
                          style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ]),
                  ),
                  _verifiedBadge('✦ Hajj 1447H'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _statsStrip([
              ('18',   'Meals Ordered', NusuqColors.brightGreen),
              ('4.9★', 'Avg Rating',    NusuqColors.gold),
              ('6',    'Days Active',   Colors.white),
            ]),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  // CARDS
  // ════════════════════════════════════════
  Widget _buildPersonalInfo() => _card(
    icon: '👤', iconBg: NusuqColors.mintSurface,
    title: 'Personal Information', action: 'Edit',
    child: Column(children: [
      _row('Full Name',    'Hamida Akhtar'),
      _row('Nationality',  '🇵🇰 Pakistani'),
      _row('Passport No.', 'AK-7291043'),
      _row('Phone',        '+92 300 1234567'),
      _row('Campaign',     'Al-Nour Group', vc: NusuqColors.midGreen),
    ]),
  );

  Widget _buildDietaryNeeds() => _card(
    icon: '🥗', iconBg: NusuqColors.mintSurface,
    title: 'Dietary & Health Needs', action: 'Edit',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _row('Health Condition', 'Type 2 Diabetes'),
      _row('Allergies',        '🥜 Nuts, 🌾 Gluten'),
      _row('Meal Preference',  'Low Carb', vc: NusuqColors.midGreen),
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
        child: Wrap(spacing: 8, runSpacing: 8, children: [
          _tag('🌱 Vegan',        on: true),
          _tag('🌾 Gluten-Free',  on: true),
          _tag('🩸 Diabetic',     on: true),
          _tag('🥩 High Protein', on: false),
          _tag('❤️ Heart Diet',   on: false),
          _tag('🥜 Nut Allergy',  on: false),
        ]),
      ),
    ]),
  );

  Widget _buildMyStats() => _card(
    icon: '📊', iconBg: NusuqColors.goldSurface,
    title: 'My Statistics',
    child: Column(children: [
      _row('Total Meals',      '18 meals'),
      _row('Meals Rated',      '15 ratings'),
      _row('Avg Satisfaction', '4.9 / 5.0 ★', vc: NusuqColors.gold),
      _row('Favourite Meal',   '🥗 Grilled Chicken Salad'),
    ]),
  );

  Widget _buildSettings() => _card(
    icon: '⚙️', iconBg: const Color(0xFFF0F0F0),
    title: 'Settings & Notifications',
    child: Column(children: [
      _toggleRow('🔔', NusuqColors.mintSurface,      'Meal Reminders',  'Notify before each meal',  true),
      _toggleRow('✨', NusuqColors.mintSurface,      'AI Suggestions',  'Daily smart meal picks',   true),
      _arrowRow ('🌐', const Color(0xFFF0F0F0),      'Language',         val: 'English'),
      _arrowRow ('🔒', const Color(0xFFF0F0F0),      'Privacy & Data'),
    ]),
  );

  Widget _buildLogoutBtn() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        border: Border.all(color: const Color(0xFFFFD5D5)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('🚪', style: TextStyle(fontSize: 18)),
              SizedBox(width: 8),
              Text('Sign Out',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFE53935))),
            ]),
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
        border: Border(top: BorderSide(color: Color(0xFFEEF4F0))),
      ),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 24),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _navItem('🏠', 'Home',    false),
        _navItem('🔍', 'Explore', false),
        _navFab('🍽️'),
        _navItem('❤️', 'Saved',   false),
        _navItem('👤', 'Profile', true),
      ]),
    );
  }

  // ════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════
  Widget _editBtn() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      border: Border.all(color: Colors.white.withOpacity(0.15)),
      borderRadius: BorderRadius.circular(11),
    ),
    child: const Row(children: [
      Text('✏️', style: TextStyle(fontSize: 13)),
      SizedBox(width: 5),
      Text('Edit', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _avatar(String initials, Color c1, Color c2) => Container(
    width: 72, height: 72,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [c1, c2]),
      border: Border.all(color: Colors.white24, width: 3),
    ),
    alignment: Alignment.center,
    child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
  );

  Widget _verifiedBadge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
    decoration: BoxDecoration(
      color: NusuqColors.gold.withOpacity(0.15),
      border: Border.all(color: NusuqColors.gold.withOpacity(0.4)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: const TextStyle(color: NusuqColors.gold, fontSize: 10, fontWeight: FontWeight.w600)),
  );

  Widget _statsStrip(List<(String, String, Color)> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.07))),
      ),
      child: Row(
        children: items.map((e) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.white.withOpacity(0.07))),
            ),
            child: Column(children: [
              Text(e.$1, style: TextStyle(color: e.$3, fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(e.$2, style: const TextStyle(color: Colors.white38, fontSize: 9)),
            ]),
          ),
        )).toList(),
      ),
    );
  }

  Widget _card({required String icon, required Color iconBg, required String title, String? action, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: NusuqColors.border),
        boxShadow: [BoxShadow(color: NusuqColors.deepForest.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: NusuqColors.border))),
          child: Row(children: [
            Container(width: 26, height: 26,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Text(icon, style: const TextStyle(fontSize: 13))),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: NusuqColors.textDark)),
            const Spacer(),
            if (action != null)
              Text(action, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NusuqColors.midGreen)),
          ]),
        ),
        child,
      ]),
    );
  }

  Widget _row(String k, String v, {Color? vc}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEF5F1)))),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(fontSize: 12, color: NusuqColors.muted, fontWeight: FontWeight.w500)),
      Text(v, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: vc ?? NusuqColors.textDark)),
    ]),
  );

  Widget _tag(String label, {required bool on}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
    decoration: BoxDecoration(
      color: on ? NusuqColors.mintSurface : const Color(0xFFF5F5F5),
      border: Border.all(color: on ? NusuqColors.midGreen : const Color(0xFFEEEEEE)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
        color: on ? NusuqColors.midGreen : const Color(0xFFBBBBBB))),
  );

  Widget _toggleRow(String icon, Color bg, String label, String sub, bool on) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEF5F1)))),
    child: Row(children: [
      Container(width: 34, height: 34,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
        alignment: Alignment.center,
        child: Text(icon, style: const TextStyle(fontSize: 16))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: NusuqColors.textDark)),
        Text(sub,   style: const TextStyle(fontSize: 10, color: NusuqColors.muted)),
      ])),
      Container(
        width: 36, height: 20,
        decoration: BoxDecoration(
          color: on ? NusuqColors.midGreen : const Color(0xFFDDDDDD),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(margin: const EdgeInsets.all(3), width: 14, height: 14,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        ),
      ),
    ]),
  );

  Widget _arrowRow(String icon, Color bg, String label, {String? val}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEF5F1)))),
    child: Row(children: [
      Container(width: 34, height: 34,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(11)),
        alignment: Alignment.center,
        child: Text(icon, style: const TextStyle(fontSize: 16))),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: NusuqColors.textDark))),
      if (val != null) Text(val, style: const TextStyle(fontSize: 11, color: NusuqColors.muted)),
      const SizedBox(width: 6),
      const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC), size: 20),
    ]),
  );

  Widget _navItem(String emoji, String label, bool active) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: active ? NusuqColors.mintSurface : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(height: 3),
      Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
          color: active ? NusuqColors.midGreen : const Color(0xFFBBBBBB))),
    ]),
  );

  Widget _navFab(String emoji) => Container(
    width: 54, height: 54,
    margin: const EdgeInsets.only(bottom: 18),
    decoration: BoxDecoration(
      gradient: NusuqColors.buttonGradient,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: NusuqColors.midGreen.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
    ),
    alignment: Alignment.center,
    child: Text(emoji, style: const TextStyle(fontSize: 24)),
  );
}
