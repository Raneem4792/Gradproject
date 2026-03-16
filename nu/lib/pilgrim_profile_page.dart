import 'package:flutter/material.dart';

class PilgrimProfilePage extends StatelessWidget {
  static const String routeName = '/pilgrim-profile';

  const PilgrimProfilePage({super.key});

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFEAF4F2);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: const _PilgrimProfileAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ProfileHeaderCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Personal Information"),
            SizedBox(height: 10),
            _PersonalInfoCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Health Profile"),
            SizedBox(height: 10),
            _HealthProfileCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Meal Preference Summary"),
            SizedBox(height: 10),
            _MealSummaryCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Settings"),
            SizedBox(height: 10),
            _SettingsCard(),
            SizedBox(height: 22),

            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

class _PilgrimProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _PilgrimProfileAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(58);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.6,
      shadowColor: Colors.black.withOpacity(0.08),
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "Pilgrim Profile",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  PilgrimProfilePage.primaryDark,
                  PilgrimProfilePage.primary,
                  PilgrimProfilePage.primaryMid,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.14),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ahmed Al-Harbi",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Pilgrim ID: PG-2026-014",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Campaign: Al Noor Hajj Group",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: PilgrimProfilePage.mint.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          "Active Account",
                          style: TextStyle(
                            color: PilgrimProfilePage.primaryDark,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -28,
            top: -36,
            child: Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PilgrimProfilePage.mint.withOpacity(0.10),
              ),
            ),
          ),
          Positioned(
            left: -28,
            bottom: -36,
            child: Container(
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PilgrimProfilePage.gold.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: const [
          _CardHeader(title: "Personal Details", actionText: "Edit"),
          SizedBox(height: 10),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            title: "Full Name",
            value: "Ahmed Al-Harbi",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.email_outlined,
            title: "Email",
            value: "ahmed@example.com",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.phone_outlined,
            title: "Phone Number",
            value: "+966 5X XXX XXXX",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.lock_outline_rounded,
            title: "Password",
            value: "Change Password",
            valueColor: PilgrimProfilePage.primary,
          ),
        ],
      ),
    );
  }
}

class _HealthProfileCard extends StatelessWidget {
  const _HealthProfileCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _CardHeader(title: "Health Information", actionText: "Edit"),
          SizedBox(height: 10),
          _InfoRow(
            icon: Icons.cake_outlined,
            title: "Age",
            value: "36",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.monitor_heart_outlined,
            title: "Health Condition",
            value: "Diabetes",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.restaurant_menu_rounded,
            title: "Dietary Preference",
            value: "Low Sugar",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.warning_amber_rounded,
            title: "Allergies",
            value: "Nuts, Seafood",
          ),
          SizedBox(height: 14),
          _TagsWrap(
            tags: [
              "Diabetic",
              "Low Sugar",
              "Nut Allergy",
              "High Protein",
            ],
          ),
        ],
      ),
    );
  }
}

class _MealSummaryCard extends StatelessWidget {
  const _MealSummaryCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: const [
          _CardHeader(title: "Preference Summary"),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  title: "Orders",
                  value: "12",
                  icon: Icons.receipt_long_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MiniStatCard(
                  title: "AI Match",
                  value: "ON",
                  icon: Icons.auto_awesome_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStatCard(
                  title: "Last Meal",
                  value: "Salad",
                  icon: Icons.lunch_dining_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _MiniStatCard(
                  title: "Main Plan",
                  value: "Healthy",
                  icon: Icons.favorite_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: const [
          _CardHeader(title: "Preferences"),
          SizedBox(height: 10),
          _SettingRow(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            value: "Enabled",
          ),
          Divider(height: 22),
          _SettingRow(
            icon: Icons.language_rounded,
            title: "Language",
            value: "English",
          ),
          Divider(height: 22),
          _SettingRow(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy",
            value: "Manage",
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(
            color: Colors.red.withOpacity(0.22),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
        ),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: const Text(
          "Log Out",
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final String? actionText;

  const _CardHeader({
    required this.title,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: PilgrimProfilePage.softMint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              actionText!,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: PilgrimProfilePage.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: PilgrimProfilePage.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black.withOpacity(0.55),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.2,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: PilgrimProfilePage.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14.2,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.6,
            color: Colors.black.withOpacity(0.58),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22,
            color: PilgrimProfilePage.primary,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.58),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsWrap extends StatelessWidget {
  final List<String> tags;

  const _TagsWrap({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: PilgrimProfilePage.softMint,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: PilgrimProfilePage.mint.withOpacity(0.8),
                ),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  fontSize: 11.8,
                  fontWeight: FontWeight.w800,
                  color: PilgrimProfilePage.primary,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: child,
    );
  }
}