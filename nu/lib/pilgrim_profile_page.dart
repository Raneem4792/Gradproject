import 'package:flutter/material.dart';
import 'pilgrim_home_screen.dart';

class PilgrimProfilePage extends StatefulWidget {
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
  State<PilgrimProfilePage> createState() => _PilgrimProfilePageState();
}

class _PilgrimProfilePageState extends State<PilgrimProfilePage> {
  bool isEditingPersonal = false;
  bool isEditingHealth = false;
  bool isChangingPassword = false;

  String fullName = "Ahmed Al-Harbi";
  String email = "ahmed@example.com";
  String phone = "+966 5X XXX XXXX";

  String selectedAge = "36";
  String selectedHealthCondition = "Diabetes";
  String selectedDietaryPreference = "Low Sugar";
  List<String> selectedAllergies = ["Nuts", "Seafood"];
  List<String> tags = [];

  String tempSelectedAge = "";
  String tempSelectedHealthCondition = "";
  String tempSelectedDietaryPreference = "";
  List<String> tempSelectedAllergies = [];

  bool notificationsEnabled = true;
  String language = "English";

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  late final TextEditingController currentPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmPasswordController;

  final List<String> ageOptions = List.generate(83, (index) => "${18 + index}");

  final List<String> healthConditionOptions = const [
    "None",
    "Diabetes",
    "Hypertension",
    "Heart Disease",
    "Asthma",
    "Kidney Disease",
    "Liver Disease",
    "Thyroid Disorder",
    "High Cholesterol",
    "Arthritis",
    "Epilepsy",
    "Mobility Issue",
    "Other",
  ];

  final List<String> dietaryPreferenceOptions = const [
    "Regular",
    "Low Sugar",
    "Low Salt",
    "Vegetarian",
    "High Protein",
  ];

  final List<String> allergyOptions = const [
    "Nuts",
    "Seafood",
    "Dairy",
    "Eggs",
    "Gluten",
    "Soy",
    "Sesame",
    "Shellfish",
    "Wheat",
    "Medication",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(text: fullName);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: phone);

    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    _rebuildHealthTags();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _rebuildHealthTags() {
    final List<String> result = [];

    if (selectedHealthCondition == "Diabetes") {
      result.add("Diabetic");
    } else if (selectedHealthCondition != "None") {
      result.add(selectedHealthCondition);
    }

    if (selectedDietaryPreference.isNotEmpty &&
        selectedDietaryPreference != "Regular") {
      result.add(selectedDietaryPreference);
    }

    for (final allergy in selectedAllergies) {
      result.add("$allergy Allergy");
    }

    tags = result;
  }

  void _togglePersonalEdit() {
    if (isEditingPersonal) {
      setState(() {
        fullName = fullNameController.text.trim();
        email = emailController.text.trim();
        phone = phoneController.text.trim();
        isEditingPersonal = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Personal details updated")));
    } else {
      fullNameController.text = fullName;
      emailController.text = email;
      phoneController.text = phone;

      setState(() {
        isEditingPersonal = true;
      });
    }
  }

  void _cancelPersonalEdit() {
    setState(() {
      fullNameController.text = fullName;
      emailController.text = email;
      phoneController.text = phone;
      isEditingPersonal = false;
    });
  }

  void _toggleHealthEdit() {
    if (isEditingHealth) {
      setState(() {
        _rebuildHealthTags();
        isEditingHealth = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Health information updated")),
      );
    } else {
      tempSelectedAge = selectedAge;
      tempSelectedHealthCondition = selectedHealthCondition;
      tempSelectedDietaryPreference = selectedDietaryPreference;
      tempSelectedAllergies = List<String>.from(selectedAllergies);

      setState(() {
        isEditingHealth = true;
      });
    }
  }

  void _cancelHealthEdit() {
    setState(() {
      selectedAge = tempSelectedAge;
      selectedHealthCondition = tempSelectedHealthCondition;
      selectedDietaryPreference = tempSelectedDietaryPreference;
      selectedAllergies = List<String>.from(tempSelectedAllergies);
      _rebuildHealthTags();
      isEditingHealth = false;
    });
  }

  Future<void> _changeLanguage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Language",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text("العربية"),
                  trailing: language == "العربية"
                      ? const Icon(
                          Icons.check,
                          color: PilgrimProfilePage.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, "العربية"),
                ),
                ListTile(
                  title: const Text("English"),
                  trailing: language == "English"
                      ? const Icon(
                          Icons.check,
                          color: PilgrimProfilePage.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(context, "English"),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        language = selected;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Language changed to $selected")));
    }
  }

  void _changePassword() {
    setState(() {
      isChangingPassword = !isChangingPassword;
      if (!isChangingPassword) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      }
    });
  }

  void _savePassword() {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all password fields")),
      );
      return;
    }

    if (newPass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New password must be at least 8 characters"),
        ),
      );
      return;
    }

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("New password and confirm password do not match"),
        ),
      );
      return;
    }

    setState(() {
      isChangingPassword = false;
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password changed successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilgrimProfilePage.bg,
      appBar: const _PilgrimProfileAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeaderCard(fullName: fullName),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Personal Information"),
            const SizedBox(height: 10),
            _PersonalInfoCard(
              isEditing: isEditingPersonal,
              fullName: fullName,
              email: email,
              phone: phone,
              fullNameController: fullNameController,
              emailController: emailController,
              phoneController: phoneController,
              onEditTap: _togglePersonalEdit,
              onCancelTap: _cancelPersonalEdit,
              onChangePassword: _changePassword,
              isChangingPassword: isChangingPassword,
              currentPasswordController: currentPasswordController,
              newPasswordController: newPasswordController,
              confirmPasswordController: confirmPasswordController,
              onSavePassword: _savePassword,
            ),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Health Profile"),
            const SizedBox(height: 10),
            _HealthProfileCard(
              isEditing: isEditingHealth,
              selectedAge: selectedAge,
              selectedHealthCondition: selectedHealthCondition,
              selectedDietaryPreference: selectedDietaryPreference,
              selectedAllergies: selectedAllergies,
              tags: tags,
              ageOptions: ageOptions,
              healthConditionOptions: healthConditionOptions,
              dietaryPreferenceOptions: dietaryPreferenceOptions,
              allergyOptions: allergyOptions,
              onAgeChanged: (value) {
                setState(() {
                  selectedAge = value!;
                });
              },
              onHealthConditionChanged: (value) {
                setState(() {
                  selectedHealthCondition = value!;
                });
              },
              onDietaryPreferenceChanged: (value) {
                setState(() {
                  selectedDietaryPreference = value!;
                });
              },
              onAllergyToggle: (allergy, selected) {
                setState(() {
                  if (selected) {
                    if (!selectedAllergies.contains(allergy)) {
                      selectedAllergies.add(allergy);
                    }
                  } else {
                    selectedAllergies.remove(allergy);
                  }
                });
              },
              onEditTap: _toggleHealthEdit,
              onCancelTap: _cancelHealthEdit,
            ),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Meal Preference Summary"),
            const SizedBox(height: 10),
            const _MealSummaryCard(),
            const SizedBox(height: 16),

            const _SectionTitle(title: "Settings"),
            const SizedBox(height: 10),
            _SettingsCard(
              notificationsEnabled: notificationsEnabled,
              language: language,
              onNotificationsChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
              onLanguageTap: _changeLanguage,
            ),
            const SizedBox(height: 22),

            const _LogoutButton(),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PilgrimHomeScreen()),
              );
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
      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String fullName;

  const _ProfileHeaderCard({required this.fullName});

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
                      Text(
                        fullName,
                        style: const TextStyle(
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
  final bool isEditing;
  final String fullName;
  final String email;
  final String phone;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;
  final VoidCallback onChangePassword;
  final bool isChangingPassword;
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSavePassword;

  const _PersonalInfoCard({
    required this.isEditing,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.onEditTap,
    required this.onCancelTap,
    required this.onChangePassword,
    required this.isChangingPassword,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.onSavePassword,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          _CardHeader(
            title: "Personal Details",
            actionText: isEditing ? "Save" : "Edit",
            onActionTap: onEditTap,
            showCancel: isEditing,
            onCancelTap: onCancelTap,
          ),
          const SizedBox(height: 10),
          if (isEditing) ...[
            _EditableField(
              icon: Icons.person_outline_rounded,
              label: "Full Name",
              controller: fullNameController,
            ),
            const SizedBox(height: 14),
            _EditableField(
              icon: Icons.email_outlined,
              label: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 14),
            _EditableField(
              icon: Icons.phone_outlined,
              label: "Phone Number",
              controller: phoneController,
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.lock_outline_rounded,
              title: "Password",
              value: "Change Password",
              valueColor: PilgrimProfilePage.primary,
              onTap: onChangePassword,
            ),
          ] else ...[
            _InfoRow(
              icon: Icons.person_outline_rounded,
              title: "Full Name",
              value: fullName,
            ),
            const Divider(height: 22),
            _InfoRow(icon: Icons.email_outlined, title: "Email", value: email),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.phone_outlined,
              title: "Phone Number",
              value: phone,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.lock_outline_rounded,
              title: "Password",
              value: "Change Password",
              valueColor: PilgrimProfilePage.primary,
              onTap: onChangePassword,
            ),
          ],
          if (isChangingPassword) ...[
            const SizedBox(height: 14),
            _EditableField(
              icon: Icons.lock_outline_rounded,
              label: "Current Password",
              controller: currentPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _EditableField(
              icon: Icons.lock_reset_rounded,
              label: "New Password",
              controller: newPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _EditableField(
              icon: Icons.lock_person_rounded,
              label: "Confirm New Password",
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSavePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PilgrimProfilePage.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save New Password",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HealthProfileCard extends StatelessWidget {
  final bool isEditing;
  final String selectedAge;
  final String selectedHealthCondition;
  final String selectedDietaryPreference;
  final List<String> selectedAllergies;
  final List<String> tags;

  final List<String> ageOptions;
  final List<String> healthConditionOptions;
  final List<String> dietaryPreferenceOptions;
  final List<String> allergyOptions;

  final ValueChanged<String?> onAgeChanged;
  final ValueChanged<String?> onHealthConditionChanged;
  final ValueChanged<String?> onDietaryPreferenceChanged;
  final void Function(String allergy, bool selected) onAllergyToggle;

  final VoidCallback onEditTap;
  final VoidCallback onCancelTap;

  const _HealthProfileCard({
    required this.isEditing,
    required this.selectedAge,
    required this.selectedHealthCondition,
    required this.selectedDietaryPreference,
    required this.selectedAllergies,
    required this.tags,
    required this.ageOptions,
    required this.healthConditionOptions,
    required this.dietaryPreferenceOptions,
    required this.allergyOptions,
    required this.onAgeChanged,
    required this.onHealthConditionChanged,
    required this.onDietaryPreferenceChanged,
    required this.onAllergyToggle,
    required this.onEditTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: "Health Information",
            actionText: isEditing ? "Save" : "Edit",
            onActionTap: onEditTap,
            showCancel: isEditing,
            onCancelTap: onCancelTap,
          ),
          const SizedBox(height: 10),
          if (isEditing) ...[
            _InlineAgeSelector(
              age: selectedAge,
              onAgeChanged: (value) {
                onAgeChanged(value);
              },
            ),
            const SizedBox(height: 14),
            _DropdownField(
              icon: Icons.monitor_heart_outlined,
              label: "Health Condition",
              value: selectedHealthCondition,
              items: healthConditionOptions,
              onChanged: onHealthConditionChanged,
            ),
            const SizedBox(height: 14),
            _DropdownField(
              icon: Icons.restaurant_menu_rounded,
              label: "Dietary Preference",
              value: selectedDietaryPreference,
              items: dietaryPreferenceOptions,
              onChanged: onDietaryPreferenceChanged,
            ),
            const SizedBox(height: 14),
            _MultiSelectAllergyField(
              icon: Icons.warning_amber_rounded,
              label: "Allergies",
              items: allergyOptions,
              selectedItems: selectedAllergies,
              onToggle: onAllergyToggle,
            ),
          ] else ...[
            _InfoRow(
              icon: Icons.cake_outlined,
              title: "Age",
              value: selectedAge,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.monitor_heart_outlined,
              title: "Health Condition",
              value: selectedHealthCondition,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.restaurant_menu_rounded,
              title: "Dietary Preference",
              value: selectedDietaryPreference,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.warning_amber_rounded,
              title: "Allergies",
              value: selectedAllergies.isEmpty
                  ? "None"
                  : selectedAllergies.join(", "),
            ),
            const SizedBox(height: 14),
            _TagsWrap(tags: tags),
          ],
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
  final bool notificationsEnabled;
  final String language;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLanguageTap;

  const _SettingsCard({
    required this.notificationsEnabled,
    required this.language,
    required this.onNotificationsChanged,
    required this.onLanguageTap,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        children: [
          const _CardHeader(title: "Preferences"),
          const SizedBox(height: 10),
          _SwitchSettingRow(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),
          const Divider(height: 22),
          _SettingRow(
            icon: Icons.language_rounded,
            title: "Language",
            value: language,
            onTap: onLanguageTap,
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
          side: BorderSide(color: Colors.red.withOpacity(0.22)),
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
  final VoidCallback? onActionTap;
  final bool showCancel;
  final VoidCallback? onCancelTap;

  const _CardHeader({
    required this.title,
    this.actionText,
    this.onActionTap,
    this.showCancel = false,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        if (showCancel)
          TextButton(
            onPressed: onCancelTap,
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),
            ),
          ),
        if (actionText != null)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onActionTap,
            child: Container(
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
          ),
      ],
    );
  }
}

class _EditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _EditableField({
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: PilgrimProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF8FAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(
                  color: PilgrimProfilePage.primary,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InlineAgeSelector extends StatelessWidget {
  final String age;
  final ValueChanged<String> onAgeChanged;
  final int minAge;
  final int maxAge;

  const _InlineAgeSelector({
    required this.age,
    required this.onAgeChanged,
    this.minAge = 18,
    this.maxAge = 150,
  });

  @override
  Widget build(BuildContext context) {
    final currentAge = int.tryParse(age) ?? 18;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.cake_outlined,
            color: PilgrimProfilePage.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Age",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Minus Button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: currentAge > minAge
                            ? PilgrimProfilePage.primary
                            : Colors.black.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: currentAge > minAge
                              ? () {
                                  onAgeChanged("${currentAge - 1}");
                                }
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            Icons.remove_rounded,
                            color: currentAge > minAge
                                ? Colors.white
                                : Colors.black.withOpacity(0.4),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Age Value
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PilgrimProfilePage.softMint.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$currentAge",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: PilgrimProfilePage.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Plus Button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: currentAge < maxAge
                            ? PilgrimProfilePage.primary
                            : Colors.black.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: currentAge < maxAge
                              ? () {
                                  onAgeChanged("${currentAge + 1}");
                                }
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            Icons.add_rounded,
                            color: currentAge < maxAge
                                ? Colors.white
                                : Colors.black.withOpacity(0.4),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: PilgrimProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map(
                  (item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF8FAFA),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(
                  color: PilgrimProfilePage.primary,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MultiSelectAllergyField extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;
  final List<String> selectedItems;
  final void Function(String allergy, bool selected) onToggle;

  const _MultiSelectAllergyField({
    required this.icon,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: PilgrimProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) {
                    final selected = selectedItems.contains(item);
                    return FilterChip(
                      label: Text(item),
                      selected: selected,
                      onSelected: (value) => onToggle(item, value),
                      selectedColor: PilgrimProfilePage.mint.withOpacity(0.35),
                      checkmarkColor: PilgrimProfilePage.primary,
                      side: BorderSide(
                        color: PilgrimProfilePage.mint.withOpacity(0.8),
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: PilgrimProfilePage.primary,
                      ),
                    );
                  }).toList(),
                ),
              ],
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
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: PilgrimProfilePage.softMint,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: PilgrimProfilePage.primary, size: 21),
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

    if (onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: child,
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: PilgrimProfilePage.softMint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: PilgrimProfilePage.primary, size: 21),
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
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _SwitchSettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
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
          child: Icon(icon, color: PilgrimProfilePage.primary, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14.2, fontWeight: FontWeight.w800),
          ),
        ),
        Transform.scale(
          scale: 0.82,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: PilgrimProfilePage.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          Icon(icon, size: 22, color: PilgrimProfilePage.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
