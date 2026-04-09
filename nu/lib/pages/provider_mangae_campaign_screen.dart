import 'package:flutter/material.dart';
import '../widgets/provider_bottom_nav.dart';
import 'provider_home_screen.dart';
import 'incoming_meal_requests_page.dart';
import 'provider_dashboard_page.dart';
import '../services/campaign_service.dart';
import '../models/campaign.dart';
import '../session/user_session.dart';

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

  final CampaignService _campaignService = CampaignService();
  List<Campaign> _campaigns = [];
  bool _isLoading = true;

  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

Future<void> _loadCampaigns() async {
  print('1- _loadCampaigns started');

  try {
    final providerID = UserSession.userId;
    print('2- providerID = $providerID');

    if (providerID == null || providerID.isEmpty) {
      throw Exception('Provider ID not found in session');
    }

    final campaigns =
        await _campaignService.getCampaignsByProvider(providerID);

    print('3- campaigns fetched = ${campaigns.length}');

    if (!mounted) return;

    setState(() {
      _campaigns = campaigns;
      _isLoading = false;
    });

    print('4- setState done');
  } catch (e) {
    print('ERROR in _loadCampaigns: $e');

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }
}

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
    final created = await showModalBottomSheet<_CampaignFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => const _CampaignFormSheet(mode: _FormMode.add),
    );

    if (created == null) return;

    try {
      final providerID = UserSession.userId;
      if (providerID == null || providerID.isEmpty) {
        throw Exception('Provider ID not found in session');
      }

      await _campaignService.createCampaign(
        campaignName: created.campaignName,
        campaignNumber: created.campaignNumber,
        numberOfPilgrims: created.numberOfPilgrims,
        arrivalDetails: created.arrivalDetails,
        providerID: providerID,
      );

      await _loadCampaigns();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add campaign: $e')),
      );
    }
  }

  void _openEditSheet(Campaign campaign) async {
    final updated = await showModalBottomSheet<_CampaignFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => _CampaignFormSheet(
        mode: _FormMode.edit,
        initial: campaign,
      ),
    );

    if (updated == null) return;

    try {
      await _campaignService.updateCampaign(
        campaignID: campaign.campaignID,
        campaignName: updated.campaignName,
        campaignNumber: updated.campaignNumber,
        numberOfPilgrims: updated.numberOfPilgrims,
        arrivalDetails: updated.arrivalDetails,
      );

      await _loadCampaigns();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update campaign: $e')),
      );
    }
  }

  Future<void> _deleteCampaign(Campaign campaign) async {
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
          'Are you sure you want to delete "${campaign.campaignName}"?',
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

    try {
      await _campaignService.deleteCampaign(campaign.campaignID);
      await _loadCampaigns();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete campaign: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: _CampaignManagementMainAppBar(onBack: _handleBack),
      body: SafeArea(
        top: false,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
      actions: const [SizedBox(width: 6)],
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

  final Campaign campaign;
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
                  campaign.campaignName,
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
                    _CampaignNumberPill(number: campaign.campaignNumber),
                    const SizedBox(width: 8),
                    _PilgrimsCountPill(count: campaign.numberOfPilgrims),
                  ],
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.info_outline_rounded,
                  text: campaign.arrivalDetails,
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
  final Campaign? initial;

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
  late final TextEditingController _campaignNumberController;
  late final TextEditingController _arrivalDetailsController;

  late int _pilgrimsCount;

  bool get _isEdit => widget.mode == _FormMode.edit;

  @override
  void initState() {
    super.initState();

    final initial = widget.initial;

    _nameController = TextEditingController(
      text: initial?.campaignName ?? '',
    );
    _campaignNumberController = TextEditingController(
      text: initial?.campaignNumber ?? '',
    );
    _arrivalDetailsController = TextEditingController(
      text: initial?.arrivalDetails ?? '',
    );

    _pilgrimsCount = initial?.numberOfPilgrims ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _campaignNumberController.dispose();
    _arrivalDetailsController.dispose();
    super.dispose();
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

    final result = _CampaignFormResult(
      campaignName: _nameController.text.trim(),
      campaignNumber: _campaignNumberController.text.trim(),
      numberOfPilgrims: _pilgrimsCount,
      arrivalDetails: _arrivalDetailsController.text.trim(),
    );

    Navigator.pop(context, result);
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
                    : 'Enter campaign information below.',
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
              const _SectionLabel(title: 'Campaign Number'),
              const SizedBox(height: 8),
              _StyledInput(
                controller: _campaignNumberController,
                hint: 'Enter campaign number',
                prefixIcon: Icons.confirmation_number_outlined,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Campaign number is required';
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

              const SizedBox(height: 14),
              const _SectionLabel(title: 'Arrival Details'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _arrivalDetailsController,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Arrival details are required';
                  }
                  return null;
                },
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Example: Arriving on Monday at 2:30 PM from Indonesia',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: primary.withOpacity(0.10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: primary, width: 1.3),
                  ),
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

class _CampaignFormResult {
  final String campaignName;
  final String campaignNumber;
  final int numberOfPilgrims;
  final String arrivalDetails;

  _CampaignFormResult({
    required this.campaignName,
    required this.campaignNumber,
    required this.numberOfPilgrims,
    required this.arrivalDetails,
  });
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