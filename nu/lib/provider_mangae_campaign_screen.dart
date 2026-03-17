import 'package:flutter/material.dart';
import 'provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_dashboard_page.dart';

class ProviderCampaignManagementScreen extends StatefulWidget {
  const ProviderCampaignManagementScreen({super.key});
  static const routeName = '/provider-campaign-management';

  @override
  State<ProviderCampaignManagementScreen> createState() =>
      _ProviderCampaignManagementScreenState();
}

class _ProviderCampaignManagementScreenState
    extends State<ProviderCampaignManagementScreen> {
  static const Color bg = Color(0xFFF1F6F4);
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final List<_CampaignItem> _campaigns = [
    _CampaignItem(
      id: 'CAMP-001',
      campaignNumber: 'CN-1001',
      name: 'Al Noor Hajj Campaign',
      numberOfPilgrims: 45,
      arrivalDay: 'Monday',
      arrivalDate: DateTime(2026, 5, 25),
      arrivalTime: const TimeOfDay(hour: 14, minute: 30),
      arrivalFrom: 'Indonesia',
    ),
    _CampaignItem(
      id: 'CAMP-002',
      campaignNumber: 'CN-1002',
      name: 'Al Barakah Umrah Group',
      numberOfPilgrims: 28,
      arrivalDay: 'Wednesday',
      arrivalDate: DateTime(2026, 6, 3),
      arrivalTime: const TimeOfDay(hour: 9, minute: 15),
      arrivalFrom: 'Turkey',
    ),
    _CampaignItem(
      id: 'CAMP-003',
      campaignNumber: 'CN-1003',
      name: 'Taybah Pilgrims Campaign',
      numberOfPilgrims: 60,
      arrivalDay: 'Friday',
      arrivalDate: DateTime(2026, 6, 12),
      arrivalTime: const TimeOfDay(hour: 18, minute: 0),
      arrivalFrom: 'Malaysia',
    ),
  ];

  int _navIndex = 0;

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    }
  }

  void _handleBottomNavTap(int i) {
    if (i == _navIndex) return;

    setState(() => _navIndex = i);

    if (i == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    } else if (i == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IncomingMealRequestsPage()),
      );
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderDashboardPage()),
      );
    } else if (i == 3) {
      Navigator.pushReplacementNamed(context, '/providerProfile');
    }
  }

  void _openAddSheet() async {
    final created = await showModalBottomSheet<_CampaignItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const _CampaignFormSheet(mode: _FormMode.add),
    );

    if (created == null) return;

    setState(() {
      _campaigns.insert(
        0,
        created.copyWith(id: _generateId(), campaignNumber: null),
      );
    });
  }

  void _openEditSheet(_CampaignItem campaign) async {
    final updated = await showModalBottomSheet<_CampaignItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) =>
          _CampaignFormSheet(mode: _FormMode.edit, initial: campaign),
    );

    if (updated == null) return;

    setState(() {
      final idx = _campaigns.indexWhere((c) => c.id == campaign.id);
      if (idx != -1) {
        _campaigns[idx] = updated.copyWith(
          id: campaign.id,
          campaignNumber: campaign.campaignNumber,
        );
      }
    });
  }

  Future<void> _deleteCampaign(_CampaignItem campaign) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Delete campaign?',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Are you sure you want to delete "${campaign.name}"?',
          style: TextStyle(
            color: Colors.black.withOpacity(0.66),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: primary.withOpacity(0.85),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    if (ok != true) return;
    setState(() => _campaigns.removeWhere((c) => c.id == campaign.id));
  }

  String _generateId() {
    final n = _campaigns.length + 1;
    return 'CAMP-${n.toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _CampaignManagementMainAppBar(onBack: _handleBack),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CampaignManagementHeaderCard(
                title: "Manage Campaigns",
                badgeText: "${_campaigns.length} campaigns",
              ),
              const SizedBox(height: 14),
              _AddCampaignWideButton(onTap: _openAddSheet),
              const SizedBox(height: 16),
              ListView.separated(
                itemCount: _campaigns.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final campaign = _campaigns[i];
                  return _CampaignCard(
                    campaign: campaign,
                    onEdit: () => _openEditSheet(campaign),
                    onDelete: () => _deleteCampaign(campaign),
                  );
                },
              ),
              if (_campaigns.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Center(
                    child: Text(
                      "No campaigns added yet",
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _navIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }
}

class _CampaignManagementMainAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _CampaignManagementMainAppBar({required this.onBack});

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
      titleSpacing: 4,
      title: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
              size: 20,
            ),
          ),
          const SizedBox(width: 2),
          const Text(
            "NUSUQ",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
      actions: [const SizedBox(width: 6)],
    );
  }
}

class _CampaignManagementHeaderCard extends StatelessWidget {
  final String title;
  final String badgeText;

  const _CampaignManagementHeaderCard({
    required this.title,
    required this.badgeText,
  });

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primary, primaryMid],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 14),
            color: primary.withOpacity(0.24),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.16)),
            ),
            child: const Icon(
              Icons.campaign_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: mint.withOpacity(0.20),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: mint.withOpacity(0.45)),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 11.8,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddCampaignWideButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCampaignWideButton({required this.onTap});

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: primary.withOpacity(0.10)),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                offset: const Offset(0, 8),
                color: primary.withOpacity(0.06),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add Campaign",
                style: TextStyle(
                  color: primary.withOpacity(0.92),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: softMint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mint.withOpacity(0.60)),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: primary.withOpacity(0.90),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({
    required this.campaign,
    required this.onEdit,
    required this.onDelete,
  });

  final _CampaignItem campaign;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color primaryMid = Color(0xFF167062);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF9FCFB)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 12),
            color: primary.withOpacity(0.08),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 132,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [mint.withOpacity(0.95), primaryMid.withOpacity(0.75)],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: softMint,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: mint.withOpacity(0.55)),
            ),
            child: Icon(
              Icons.campaign_rounded,
              color: primary.withOpacity(0.80),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: primaryDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _CampaignNumberPill(
                      number: campaign.campaignNumber ?? 'Pending',
                    ),
                    const SizedBox(width: 8),
                    _PilgrimsCountPill(count: campaign.numberOfPilgrims),
                  ],
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  text:
                      'Arrival Day: ${campaign.arrivalDay} • ${_formatDate(campaign.arrivalDate)}',
                ),
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Icons.access_time_rounded,
                  text:
                      'Arrival Time: ${_formatTime(campaign.arrivalTime)} • From ${campaign.arrivalFrom}',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: primary.withOpacity(0.20)),
                          foregroundColor: primary,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text(
                          'Edit',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFFFF1F0),
                          foregroundColor: const Color(0xFFB3261E),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                        ),
                        label: const Text(
                          'Delete',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignFormSheet extends StatefulWidget {
  final _FormMode mode;
  final _CampaignItem? initial;

  const _CampaignFormSheet({required this.mode, this.initial});

  @override
  State<_CampaignFormSheet> createState() => _CampaignFormSheetState();
}

class _CampaignFormSheetState extends State<_CampaignFormSheet> {
  static const Color primaryDark = Color(0xFF052720);
  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _arrivalFromController;

  late DateTime _arrivalDate;
  late TimeOfDay _arrivalTime;
  late String _arrivalDay;
  late int _pilgrimsCount;

  bool get _isEdit => widget.mode == _FormMode.edit;

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;

    _nameController = TextEditingController(text: initial?.name ?? '');
    _arrivalFromController = TextEditingController(
      text: initial?.arrivalFrom ?? '',
    );

    _arrivalDate = initial?.arrivalDate ?? DateTime.now();
    _arrivalTime = initial?.arrivalTime ?? const TimeOfDay(hour: 12, minute: 0);
    _arrivalDay = initial?.arrivalDay ?? _dayNameFromDate(_arrivalDate);
    _pilgrimsCount = initial?.numberOfPilgrims ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _arrivalFromController.dispose();
    super.dispose();
  }

  Future<void> _pickArrivalDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _arrivalDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _arrivalDate = picked;
      _arrivalDay = _dayNameFromDate(picked);
    });
  }

  Future<void> _pickArrivalTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _arrivalTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _arrivalTime = picked;
    });
  }

  void _increasePilgrims() {
    setState(() {
      _pilgrimsCount++;
    });
  }

  void _decreasePilgrims() {
    if (_pilgrimsCount <= 1) return;
    setState(() {
      _pilgrimsCount--;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final item = _CampaignItem(
      id: widget.initial?.id ?? '',
      campaignNumber: widget.initial?.campaignNumber,
      name: _nameController.text.trim(),
      numberOfPilgrims: _pilgrimsCount,
      arrivalDay: _arrivalDay,
      arrivalDate: _arrivalDate,
      arrivalTime: _arrivalTime,
      arrivalFrom: _arrivalFromController.text.trim(),
    );

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _isEdit ? 'Edit Campaign' : 'Add New Campaign',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _isEdit
                    ? 'Update campaign details below.'
                    : 'Enter campaign information and arrival details.',
                style: TextStyle(
                  fontSize: 13.3,
                  height: 1.35,
                  color: Colors.black.withOpacity(0.62),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),

              const _SectionLabel(title: 'Campaign Name'),
              const SizedBox(height: 8),
              _StyledInput(
                controller: _nameController,
                hint: 'Enter campaign name',
                prefixIcon: Icons.campaign_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Campaign name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),
              const _SectionLabel(title: 'Number of Pilgrims'),
              const SizedBox(height: 8),
              _PilgrimsCounter(
                count: _pilgrimsCount,
                onIncrease: _increasePilgrims,
                onDecrease: _decreasePilgrims,
              ),

              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: softMint,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: mint.withOpacity(0.55)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Arrival Details',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: primaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enter arrival day, date, time, and where the pilgrims are coming from.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.black.withOpacity(0.62),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _PickerTile(
                            label: 'Arrival Day',
                            value: _arrivalDay,
                            icon: Icons.today_rounded,
                            onTap: null,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PickerTile(
                            label: 'Arrival Date',
                            value: _formatDate(_arrivalDate),
                            icon: Icons.calendar_month_rounded,
                            onTap: _pickArrivalDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: _PickerTile(
                            label: 'Arrival Time',
                            value: _formatTime(_arrivalTime),
                            icon: Icons.access_time_rounded,
                            onTap: _pickArrivalTime,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StyledInput(
                            controller: _arrivalFromController,
                            hint: 'Country / city of origin',
                            prefixIcon: Icons.location_on_outlined,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Arrival location is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: primary.withOpacity(0.22)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _isEdit ? 'Save Changes' : 'Add Campaign',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
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
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13.2,
        fontWeight: FontWeight.w800,
        color: Color(0xFF052720),
      ),
    );
  }
}

class _StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const _StyledInput({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.38),
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(prefixIcon, color: primary.withOpacity(0.78)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary.withOpacity(0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB3261E)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: mint.withOpacity(0.40)),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool readOnly;

  const _PickerTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.readOnly = false,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.10)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F6F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: mint.withOpacity(0.60)),
                ),
                child: Icon(icon, color: primary.withOpacity(0.85), size: 19),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.4,
                        color: Colors.black.withOpacity(0.52),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.2,
                        color: Color(0xFF052720),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              if (!readOnly)
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: primary.withOpacity(0.82),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PilgrimsCounter extends StatelessWidget {
  final int count;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const _PilgrimsCounter({
    required this.count,
    required this.onIncrease,
    required this.onDecrease,
  });

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          _CounterButton(icon: Icons.remove_rounded, onTap: onDecrease),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF052720),
                    ),
                  ),
                  Text(
                    'Pilgrims',
                    style: TextStyle(
                      fontSize: 12.2,
                      color: Colors.black.withOpacity(0.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _CounterButton(icon: Icons.add_rounded, onTap: onIncrease),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  static const Color primary = Color(0xFF0B4A40);
  static const Color mint = Color(0xFFA8E7CF);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: softMint,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: mint.withOpacity(0.65)),
          ),
          child: Icon(icon, color: primary.withOpacity(0.90), size: 22),
        ),
      ),
    );
  }
}

class _CampaignNumberPill extends StatelessWidget {
  final String number;

  const _CampaignNumberPill({required this.number});

  static const Color primary = Color(0xFF0B4A40);
  static const Color softMint = Color(0xFFE6F6F0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: softMint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.12)),
      ),
      child: Text(
        number,
        style: TextStyle(
          fontSize: 11.5,
          color: primary.withOpacity(0.88),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PilgrimsCountPill extends StatelessWidget {
  final int count;

  const _PilgrimsCountPill({required this.count});

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: primary.withOpacity(0.12)),
      ),
      child: Text(
        '$count pilgrims',
        style: TextStyle(
          fontSize: 11.5,
          color: primary.withOpacity(0.88),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  static const Color primary = Color(0xFF0B4A40);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: primary.withOpacity(0.80)),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.6,
              color: Colors.black.withOpacity(0.68),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

enum _FormMode { add, edit }

class _CampaignItem {
  final String id;
  final String? campaignNumber;
  final String name;
  final int numberOfPilgrims;
  final String arrivalDay;
  final DateTime arrivalDate;
  final TimeOfDay arrivalTime;
  final String arrivalFrom;

  const _CampaignItem({
    required this.id,
    this.campaignNumber,
    required this.name,
    required this.numberOfPilgrims,
    required this.arrivalDay,
    required this.arrivalDate,
    required this.arrivalTime,
    required this.arrivalFrom,
  });

  _CampaignItem copyWith({
    String? id,
    String? campaignNumber,
    bool clearCampaignNumber = false,
    String? name,
    int? numberOfPilgrims,
    String? arrivalDay,
    DateTime? arrivalDate,
    TimeOfDay? arrivalTime,
    String? arrivalFrom,
  }) {
    return _CampaignItem(
      id: id ?? this.id,
      campaignNumber: clearCampaignNumber
          ? null
          : (campaignNumber ?? this.campaignNumber),
      name: name ?? this.name,
      numberOfPilgrims: numberOfPilgrims ?? this.numberOfPilgrims,
      arrivalDay: arrivalDay ?? this.arrivalDay,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      arrivalFrom: arrivalFrom ?? this.arrivalFrom,
    );
  }
}

String _formatDate(DateTime date) {
  final dd = date.day.toString().padLeft(2, '0');
  final mm = date.month.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  return '$dd/$mm/$yyyy';
}

String _formatTime(TimeOfDay time) {
  final hh = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final mm = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hh:$mm $period';
}

String _dayNameFromDate(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return 'Monday';
    case DateTime.tuesday:
      return 'Tuesday';
    case DateTime.wednesday:
      return 'Wednesday';
    case DateTime.thursday:
      return 'Thursday';
    case DateTime.friday:
      return 'Friday';
    case DateTime.saturday:
      return 'Saturday';
    case DateTime.sunday:
      return 'Sunday';
    default:
      return '';
  }
}
