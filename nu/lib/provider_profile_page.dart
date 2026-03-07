import 'package:flutter/material.dart';
import 'nusuq_colors.dart';

class ProviderProfilePage extends StatelessWidget {
  const ProviderProfilePage({super.key});

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
                        _buildCompanyInfo(),
                        const SizedBox(height: 14),
                        _buildPerformance(),
                        const SizedBox(height: 14),
                        _buildMealsOffered(),
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
                  const Text('Provider Profile',
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
                  _avatar('AB', NusuqColors.darkGold, NusuqColors.gold),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(text: 'Al-Baraka ', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'Catering',   style: TextStyle(color: NusuqColors.gold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('📍 Makkah Al-Mukarramah',
                          style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ]),
                  ),
                  _verifiedBadge('✦ Licensed'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _statsStrip([
              ('142', 'Pilgrims Served', NusuqColors.brightGreen),
              ('4.8★','Rating',          NusuqColors.gold),
              ('2',   'Campaigns',       Colors.white),
            ]),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  // CARDS
  // ════════════════════════════════════════
  Widget _buildCompanyInfo() => _card(
    icon: '🏢', iconBg: NusuqColors.goldSurface,
    title: 'Company Information', action: 'Edit',
    child: Column(children: [
      _row('Company Name', 'Al-Baraka Catering Co.'),
      _row('License No.',  'SA-2024-CT-0481', vc: NusuqColors.gold),
      _row('Contact',      '+966 50 987 6543'),
      _row('Email',        'info@albaraka.sa'),
      _row('Capacity',     'Up to 500 pilgrims/day', vc: NusuqColors.midGreen),
    ]),
  );

  Widget _buildPerformance() => _card(
    icon: '📊', iconBg: NusuqColors.mintSurface,
    title: 'Performance', action: 'Full Report',
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(children: [
        // Bar chart
        SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _bar('On Time',     0.92, NusuqColors.midGreen,  NusuqColors.brightGreen, '92%'),
              const SizedBox(width: 8),
              _bar('Rating',      0.80, NusuqColors.darkGold,  NusuqColors.gold,         '4.8'),
              const SizedBox(width: 8),
              _bar('Accuracy',    0.96, NusuqColors.midGreen,  NusuqColors.brightGreen, '96%'),
              const SizedBox(width: 8),
              _bar('Satisfaction',0.88, NusuqColors.midGreen,  NusuqColors.brightGreen, '88%'),
              const SizedBox(width: 8),
              _bar('Waste',       0.03, const Color(0xFFC0392B), const Color(0xFFE74C3C), '3%'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: NusuqColors.border),
        const SizedBox(height: 10),
        // Summary row
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _perfStat('142',  'Total Pilgrims', Colors.white),
          _perfStat('856',  'Meals Delivered', NusuqColors.gold),
          _perfStat('2',    'Active Campaigns', NusuqColors.midGreen),
        ]),
      ]),
    ),
  );

  Widget _buildMealsOffered() => _card(
    icon: '🍽️', iconBg: NusuqColors.mintSurface,
    title: 'Meals Offered', action: 'Manage',
    child: Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Column(children: [
        _mealItem('🥗', 'Grilled Chicken Salad', 'Low carb · Gluten-free · 420 kcal', 'Active', true),
        const SizedBox(height: 8),
        _mealItem('🍚', 'Lamb Rice Kabsa',       'Traditional · 680 kcal',             'Active', true),
        const SizedBox(height: 8),
        _mealItem('🥘', 'Diabetic Lentil Soup',  'Low sugar · Vegan · 310 kcal',       'New',    false),
      ]),
    ),
  );

  Widget _buildSettings() => _card(
    icon: '⚙️', iconBg: const Color(0xFFF0F0F0),
    title: 'Settings & Notifications',
    child: Column(children: [
      _toggleRow('🔔', NusuqColors.mintSurface,      'New Order Alerts',  'Notify on new requests',    true),
      _toggleRow('📈', NusuqColors.goldSurface,      'Daily Reports',     'Performance summary',       true),
      _arrowRow ('🌐', const Color(0xFFF0F0F0),      'Language',          val: 'العربية'),
      _arrowRow ('🔒', const Color(0xFFF0F0F0),      'Account Security'),
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
        _navItem('📋', 'Orders',  false),
        _navFab('➕'),
        _navItem('📊', 'Reports', false),
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

  Widget _bar(String label, double ratio, Color c1, Color c2, String val) {
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text(val, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NusuqColors.textDark)),
        const SizedBox(height: 4),
        Container(
          height: 70 * ratio,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [c1, c2]),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 8, color: NusuqColors.muted), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _perfStat(String num, String label, Color c) => Column(children: [
    Text(num,   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c)),
    const SizedBox(height: 3),
    Text(label, style: const TextStyle(fontSize: 9, color: NusuqColors.muted)),
  ]);

  Widget _mealItem(String emoji, String name, String detail, String badge, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: NusuqColors.appBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NusuqColors.border),
      ),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name,   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: NusuqColors.textDark)),
          Text(detail, style: const TextStyle(fontSize: 10, color: NusuqColors.muted)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: isActive ? NusuqColors.mintSurface : NusuqColors.goldSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(badge,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
              color: isActive ? NusuqColors.midGreen : const Color(0xFF8A6820))),
        ),
      ]),
    );
  }

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
