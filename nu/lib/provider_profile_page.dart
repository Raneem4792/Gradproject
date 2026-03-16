import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProviderProfilePage extends StatelessWidget {
  static const String routeName = '/provider-profile';

  const ProviderProfilePage({super.key});

  static const Color bg = Color(0xFFF3F6F5);
  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color softMint = Color(0xFFE8F6F1);
  static const Color gold = Color(0xFFF0E0C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        shadowColor: Colors.black.withOpacity(0.08),
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Provider Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _ProfileHeaderCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Basic Information"),
            SizedBox(height: 10),
            _InfoCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Orders Summary"),
            SizedBox(height: 10),
            _StatsGrid(),
            SizedBox(height: 16),

            _SectionTitle(title: "Linked Campaigns"),
            SizedBox(height: 10),
            _CampaignsCard(),
            SizedBox(height: 16),

            _SectionTitle(title: "Account Settings"),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Colors.black.withOpacity(0.8),
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              offset: const Offset(0, 14),
              color: Colors.black.withOpacity(0.07),
            ),
          ],
        ),
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
                    ProviderProfilePage.primaryDark,
                    ProviderProfilePage.primary,
                    ProviderProfilePage.primaryMid,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.28),
                        width: 1.4,
                      ),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Al Barakah Catering",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Meal Provider",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.88),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: ProviderProfilePage.mint.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "Verified Account",
                      style: TextStyle(
                        color: ProviderProfilePage.primaryDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -28,
              top: -36,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: ProviderProfilePage.mint.withOpacity(0.11),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -35,
              bottom: -45,
              child: Container(
                width: 135,
                height: 135,
                decoration: BoxDecoration(
                  color: ProviderProfilePage.gold.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: const [
          _InfoRow(
            icon: Icons.badge_outlined,
            title: "Provider ID",
            value: "PR-2026-014",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.email_outlined,
            title: "Email",
            value: "provider@nusuq.com",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.phone_outlined,
            title: "Phone",
            value: "+966 5X XXX XXXX",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.location_on_outlined,
            title: "Location",
            value: "Makkah",
          ),
          Divider(height: 22),
          _InfoRow(
            icon: Icons.room_service_outlined,
            title: "Service Type",
            value: "Meal Provider",
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
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
            color: ProviderProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: ProviderProfilePage.primary, size: 21),
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
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: "Total Orders",
                value: "145",
                icon: Icons.receipt_long_rounded,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: "Accepted",
                value: "120",
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: "Rejected",
                value: "25",
                icon: Icons.cancel_outlined,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: "Campaigns",
                value: "3",
                icon: Icons.campaign_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ProviderProfilePage.primary, size: 24),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignsCard extends StatelessWidget {
  const _CampaignsCard();

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: const [
          _CampaignTile(
            title: "Al Noor Hajj Campaign",
            campaignId: "CN-1001",
            pilgrimsCount: "45 pilgrims",
            arrivalDay: "Monday",
            arrivalDate: "25/05/2026",
            arrivalTime: "2:30 PM",
            fromCountry: "Indonesia",
          ),
          SizedBox(height: 12),
          _CampaignTile(
            title: "Rahma Hajj Campaign",
            campaignId: "CN-1002",
            pilgrimsCount: "38 pilgrims",
            arrivalDay: "Wednesday",
            arrivalDate: "27/05/2026",
            arrivalTime: "11:00 AM",
            fromCountry: "Turkey",
          ),
          SizedBox(height: 12),
          _CampaignTile(
            title: "Al Huda Hajj Campaign",
            campaignId: "CN-1003",
            pilgrimsCount: "52 pilgrims",
            arrivalDay: "Friday",
            arrivalDate: "29/05/2026",
            arrivalTime: "4:15 PM",
            fromCountry: "Malaysia",
          ),
        ],
      ),
    );
  }
}

class _CampaignTile extends StatelessWidget {
  final String title;
  final String campaignId;
  final String pilgrimsCount;
  final String arrivalDay;
  final String arrivalDate;
  final String arrivalTime;
  final String fromCountry;

  const _CampaignTile({
    required this.title,
    required this.campaignId,
    required this.pilgrimsCount,
    required this.arrivalDay,
    required this.arrivalDate,
    required this.arrivalTime,
    required this.fromCountry,
  });

void _showCampaignDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAF8),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color(0xFF8ED8C0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// عنوان الحملة
                    Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF133B33),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// ايقونة الحملة
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F4EE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.campaign_rounded,
                            color: Color(0xFF2D6B5F),
                            size: 32,
                          ),
                        ),

                        const SizedBox(width: 14),

                        /// معلومات الحملة
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Wrap(
                                spacing: 10,
                                children: [
                                  _DialogBadge(text: campaignId),
                                  _DialogBadge(text: pilgrimsCount),
                                ],
                              ),

                              const SizedBox(height: 14),

                              _DialogDetailRow(
                                icon: Icons.calendar_today_outlined,
                                text:
                                    "Arrival Day: $arrivalDay • $arrivalDate",
                              ),

                              const SizedBox(height: 10),

                              _DialogDetailRow(
                                icon: Icons.access_time_rounded,
                                text:
                                    "Arrival Time: $arrivalTime • From $fromCountry",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    /// زر اغلاق فقط
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCampaignDialog(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ProviderProfilePage.softMint.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.groups_2_rounded,
                color: ProviderProfilePage.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}

class _DialogBadge extends StatelessWidget {
  final String text;

  const _DialogBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F4EE),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBEDFD5)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF35695E),
        ),
      ),
    );
  }
}

class _DialogDetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DialogDetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF5F6F6A)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F5C58),
            ),
          ),
        ),
      ],
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
          _SettingTile(
            icon: Icons.edit_outlined,
            title: "Edit Profile",
          ),
          Divider(height: 18),
          _SettingTile(
            icon: Icons.lock_outline_rounded,
            title: "Change Password",
          ),
          Divider(height: 18),
          _SettingTile(
            icon: Icons.notifications_none_rounded,
            title: "Notification Settings",
          ),
          Divider(height: 18),
          _SettingTile(
            icon: Icons.language_rounded,
            title: "Language",
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingTile({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ProviderProfilePage.softMint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: ProviderProfilePage.primary, size: 21),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
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