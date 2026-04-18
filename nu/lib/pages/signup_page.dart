import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

enum AccountType { pilgrim, provider }

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  AccountType _selectedType = AccountType.pilgrim;
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _submittedOnce = false;

  String? _generalError;
  String? _fullNameServerError;
  String? _idServerError;
  String? _passwordServerError;
  String? _campaignServerError;
  String? _phoneServerError;
  String? _emailServerError;

  final _fullNameController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _campaignController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String _selectedDialCode = '+966';

  static const List<Map<String, String>> _countryCodes = [
    {'code': '+966', 'label': '🇸🇦 SA'},
    {'code': '+971', 'label': '🇦🇪 UAE'},
    {'code': '+965', 'label': '🇰🇼 KW'},
    {'code': '+973', 'label': '🇧🇭 BH'},
    {'code': '+974', 'label': '🇶🇦 QA'},
    {'code': '+968', 'label': '🇴🇲 OM'},
    {'code': '+962', 'label': '🇯🇴 JO'},
    {'code': '+20', 'label': '🇪🇬 EG'},
    {'code': '+964', 'label': '🇮🇶 IQ'},
    {'code': '+963', 'label': '🇸🇾 SY'},
    {'code': '+961', 'label': '🇱🇧 LB'},
    {'code': '+970', 'label': '🇵🇸 PS'},
    {'code': '+967', 'label': '🇾🇪 YE'},
    {'code': '+212', 'label': '🇲🇦 MA'},
    {'code': '+213', 'label': '🇩🇿 DZ'},
    {'code': '+216', 'label': '🇹🇳 TN'},
    {'code': '+218', 'label': '🇱🇾 LY'},
    {'code': '+249', 'label': '🇸🇩 SD'},
    {'code': '+90', 'label': '🇹🇷 TR'},
    {'code': '+44', 'label': '🇬🇧 UK'},
    {'code': '+1', 'label': '🇺🇸 US'},
    {'code': '+33', 'label': '🇫🇷 FR'},
    {'code': '+49', 'label': '🇩🇪 DE'},
    {'code': '+39', 'label': '🇮🇹 IT'},
    {'code': '+34', 'label': '🇪🇸 ES'},
    {'code': '+60', 'label': '🇲🇾 MY'},
    {'code': '+62', 'label': '🇮🇩 ID'},
    {'code': '+92', 'label': '🇵🇰 PK'},
    {'code': '+91', 'label': '🇮🇳 IN'},
    {'code': '+880', 'label': '🇧🇩 BD'},
  ];

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color accent = Color(0xFF16A085);
  static const Color cardBg = Color(0xFFF8FAFA);
  static const Color inputBg = Color(0xFFF2F5F4);

  static const Color infoBg = Color(0xFFEAF4F2);
  static const Color infoBorder = Color(0xFF9CC8C0);
  static const Color infoText = Color(0xFF0D4C4A);

  @override
  void dispose() {
    _fullNameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _campaignController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _clearServerErrors() {
    _generalError = null;
    _fullNameServerError = null;
    _idServerError = null;
    _passwordServerError = null;
    _campaignServerError = null;
    _phoneServerError = null;
    _emailServerError = null;
  }

  String _normalizeSpaces(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  String _normalizeDigits(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String _normalizePhone(String value) {
    String digits = _normalizeDigits(value);

    if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    return '$_selectedDialCode$digits';
  }

  String _extractRawErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return error.toString();
  }

  Map<String, dynamic>? _extractJsonFromError(dynamic error) {
    final raw = _extractRawErrorMessage(error);

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}

    return null;
  }

  String _friendlyErrorMessage(String error) {
    final message = error.toLowerCase();

    if (message.contains('campaign id does not exist') ||
        message.contains('foreign key constraint fails') ||
        message.contains('er_no_referenced_row_2')) {
      return 'The campaign ID does not exist. Please enter a valid campaign ID.';
    }

    if (message.contains('email') && message.contains('registered')) {
      return 'This email is already registered.';
    }

    if (message.contains('phone') && message.contains('registered')) {
      return 'This phone number is already registered.';
    }

    if (message.contains('pilgrim id') && message.contains('registered')) {
      return 'This pilgrim ID is already registered.';
    }

    if (message.contains('provider id') && message.contains('registered')) {
      return 'This provider ID is already registered.';
    }

    if (message.contains('network') ||
        message.contains('socketexception') ||
        message.contains('failed host lookup')) {
      return 'Unable to connect to the server. Please make sure the backend is running.';
    }

    if (message.contains('server error')) {
      return 'Something went wrong while creating the account. Please review your data and try again.';
    }

    return error;
  }

  void _applyServerFieldError({
    required String field,
    required String message,
  }) {
    switch (field) {
      case 'fullName':
        _fullNameServerError = message;
        break;
      case 'pilgrimID':
      case 'providerID':
        _idServerError = message;
        break;
      case 'password':
        _passwordServerError = message;
        break;
      case 'campaignID':
        _campaignServerError = message;
        break;
      case 'phoneNumber':
        _phoneServerError = message;
        break;
      case 'email':
        _emailServerError = message;
        break;
      default:
        _generalError = message;
    }
  }

  String? _validateFullName(String? value) {
    final text = _normalizeSpaces(value ?? '');

    if (text.isEmpty) {
      return 'Please enter your full name';
    }

    if (text.length < 3) {
      return 'Full name must be at least 3 characters';
    }

    if (text.length > 50) {
      return 'Full name must not exceed 50 characters';
    }

    if (RegExp(r'[0-9]').hasMatch(text)) {
      return 'Full name must not contain numbers';
    }

    final isArabicOnly = RegExp(r'^[\u0600-\u06FF ]+$').hasMatch(text);
    final isEnglishOnly = RegExp(r'^[A-Za-z ]+$').hasMatch(text);

    if (!isArabicOnly && !isEnglishOnly) {
      return 'Full name must be Arabic only or English only';
    }

    return _fullNameServerError;
  }

  String? _validateId(String? value) {
    final text = (value ?? '').trim();

    if (text.isEmpty) {
      return _selectedType == AccountType.pilgrim
          ? 'Please enter your pilgrim ID'
          : 'Please enter your provider ID';
    }

    if (text.contains(' ')) {
      return 'ID must not contain spaces';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
      return 'ID must contain numbers only';
    }

    if (text.length < 6) {
      return 'ID number is too short';
    }

    if (text.length > 20) {
      return 'ID number is too long';
    }

    return _idServerError;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';

    if (text.isEmpty) {
      return 'Please enter your password';
    }

    if (text.contains(' ')) {
      return 'Password must not contain spaces';
    }

    if (text.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (text.length > 20) {
      return 'Password must not exceed 20 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(text)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(text)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(text)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(text)) {
      return 'Password must contain at least one special character';
    }

    if (!RegExp(
      r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]+$',
    ).hasMatch(text)) {
      return 'Password must use English letters, numbers, and symbols only';
    }

    return _passwordServerError;
  }

  String? _validateCampaignId(String? value) {
    final text = (value ?? '').trim();

    if (_selectedType != AccountType.pilgrim) return null;

    if (text.isEmpty) {
      return 'Please enter your campaign ID';
    }

    if (text.contains(' ')) {
      return 'Campaign ID must not contain spaces';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
      return 'Campaign ID must contain numbers only';
    }

    if (text.length > 12) {
      return 'Campaign ID is too long';
    }

    final parsed = int.tryParse(text);
    if (parsed == null || parsed <= 0) {
      return 'Campaign ID must be greater than 0';
    }

    return _campaignServerError;
  }

  String? _validatePhone(String? value) {
    final text = (value ?? '').trim();

    if (text.isEmpty) {
      return 'Please enter your phone number';
    }

    if (text.contains(' ')) {
      return 'Phone number must not contain spaces';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
      return 'Phone number must contain digits only';
    }

    if (text.startsWith('00')) {
      return 'Enter the local number only';
    }

    if (text.length < 8) {
      return 'Phone number is too short';
    }

    if (text.length > 10) {
      return 'Phone number is too long';
    }

    return _phoneServerError;
  }

  String? _validateEmail(String? value) {
    final text = (value ?? '').trim();

    if (text.isEmpty) {
      return 'Please enter your email';
    }

    if (text.contains(' ')) {
      return 'Email must not contain spaces';
    }

    if (text.length > 100) {
      return 'Email is too long';
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(text)) {
      return 'Please enter a valid email address';
    }

    return _emailServerError;
  }

  Future<void> _submit() async {
    setState(() {
      _submittedOnce = true;
      _clearServerErrors();
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String message;
      final normalizedPhone = _normalizePhone(_phoneController.text.trim());
      final normalizedEmail = _emailController.text.trim().toLowerCase();
      final normalizedFullName = _normalizeSpaces(_fullNameController.text);

      if (_selectedType == AccountType.pilgrim) {
        message = await _authService.signupPilgrim(
          pilgrimID: _idController.text.trim(),
          fullName: normalizedFullName,
          email: normalizedEmail,
          phoneNumber: normalizedPhone,
          password: _passwordController.text,
          campaignID: int.parse(_campaignController.text.trim()),
        );
      } else {
        message = await _authService.signupProvider(
          providerID: _idController.text.trim(),
          fullName: normalizedFullName,
          email: normalizedEmail,
          phoneNumber: normalizedPhone,
          password: _passwordController.text,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primary,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } catch (e) {
      if (!mounted) return;

      final errorJson = _extractJsonFromError(e);

      setState(() {
        if (errorJson != null &&
            errorJson['field'] != null &&
            errorJson['message'] != null) {
          _applyServerFieldError(
            field: errorJson['field'].toString(),
            message: errorJson['message'].toString(),
          );
        } else {
          final rawError = _extractRawErrorMessage(e);
          _generalError = _friendlyErrorMessage(rawError);
        }
      });

      _formKey.currentState?.validate();

      final snackMessage = errorJson != null && errorJson['message'] != null
          ? errorJson['message'].toString()
          : _generalError ?? 'Something went wrong';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryMid,
          content: Text(
            snackMessage,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final autoValidateMode = _submittedOnce
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Scaffold(
      backgroundColor: primaryDark,
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftPatternBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  Column(
                    children: [
                      const Text(
                        'NUSUQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Smart platform for serving pilgrims',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                          color: Colors.black.withOpacity(0.16),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autoValidateMode,
                      child: Column(
                        children: [
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Choose your account type and fill in your details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _AccountTypeSelector(
                            selectedType: _selectedType,
                            onChanged: (type) {
                              setState(() {
                                _selectedType = type;
                                _clearServerErrors();
                              });
                            },
                          ),
                          if (_generalError != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: infoBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: infoBorder),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: infoText,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _generalError!,
                                      style: const TextStyle(
                                        color: infoText,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),

                          _FieldLabel('Full Name'),
                          const SizedBox(height: 6),
                          _AppField(
                            controller: _fullNameController,
                            hintText: 'Enter your full name',
                            helperText:
                                'Arabic or English letters only, 3 to 50 characters',
                            icon: Icons.person_outline,
                            textInputAction: TextInputAction.next,
                            validator: _validateFullName,
                            onChanged: (_) {
                              if (_fullNameServerError != null) {
                                setState(() => _fullNameServerError = null);
                              }
                            },
                          ),

                          const SizedBox(height: 12),
                          _FieldLabel('ID Number'),
                          const SizedBox(height: 6),
                          _AppField(
                            controller: _idController,
                            hintText: _selectedType == AccountType.pilgrim
                                ? 'Enter your pilgrim ID'
                                : 'Enter your provider ID',
                            helperText: 'Numbers only, 6 to 20 digits',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: _validateId,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(20),
                            ],
                            onChanged: (_) {
                              if (_idServerError != null) {
                                setState(() => _idServerError = null);
                              }
                            },
                          ),

                          const SizedBox(height: 12),
                          _FieldLabel('Password'),
                          const SizedBox(height: 6),
                          _AppField(
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            helperText:
                                '8-20 chars, uppercase, lowercase, number, special char, English only',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            validator: _validatePassword,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.grey.shade500,
                                size: 20,
                              ),
                            ),
                            onChanged: (_) {
                              if (_passwordServerError != null) {
                                setState(() => _passwordServerError = null);
                              }
                            },
                          ),

                          if (_selectedType == AccountType.pilgrim) ...[
                            const SizedBox(height: 12),
                            _FieldLabel('Campaign ID'),
                            const SizedBox(height: 6),
                            _AppField(
                              controller: _campaignController,
                              hintText: 'Enter your campaign ID',
                              helperText: 'Numbers only',
                              icon: Icons.confirmation_number_outlined,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: _validateCampaignId,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                              onChanged: (_) {
                                if (_campaignServerError != null) {
                                  setState(() => _campaignServerError = null);
                                }
                              },
                            ),
                          ],

                          const SizedBox(height: 12),
                          _FieldLabel('Phone Number'),
                          const SizedBox(height: 6),
                          _PhoneField(
                            controller: _phoneController,
                            selectedDialCode: _selectedDialCode,
                            countryCodes: _countryCodes,
                            onChangedDialCode: (value) {
                              setState(() {
                                _selectedDialCode = value;
                                if (_phoneServerError != null) {
                                  _phoneServerError = null;
                                }
                              });
                            },
                            validator: _validatePhone,
                            onChanged: (_) {
                              if (_phoneServerError != null) {
                                setState(() => _phoneServerError = null);
                              }
                            },
                          ),

                          const SizedBox(height: 12),
                          _FieldLabel('Email'),
                          const SizedBox(height: 6),
                          _AppField(
                            controller: _emailController,
                            hintText: 'Enter your email',
                            helperText: 'Example: name@example.com',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: _validateEmail,
                            onChanged: (_) {
                              if (_emailServerError != null) {
                                setState(() => _emailServerError = null);
                              }
                            },
                          ),

                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                disabledBackgroundColor: primaryMid,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    LoginScreen.routeName,
                                  );
                                },
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '© NUSUQ 2026 - All rights reserved',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.82),
                      fontWeight: FontWeight.w700,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Integrated system for serving pilgrims',
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
        ],
      ),
    );
  }
}

class _AccountTypeSelector extends StatelessWidget {
  final AccountType selectedType;
  final ValueChanged<AccountType> onChanged;

  const _AccountTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TypeButton(
            label: 'Pilgrim',
            selected: selectedType == AccountType.pilgrim,
            onTap: () => onChanged(AccountType.pilgrim),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TypeButton(
            label: 'Provider',
            selected: selectedType == AccountType.provider,
            onTap: () => onChanged(AccountType.provider),
          ),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const Color primary = Color(0xFF0D4C4A);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? primary : Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF374151),
        ),
      ),
    );
  }
}

class _AppField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? helperText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const _AppField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.helperText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.textInputAction,
    this.onChanged,
    this.inputFormatters,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color inputBg = Color(0xFFF2F5F4);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        helperMaxLines: 2,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        helperStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
          fontSize: 11.5,
        ),
        errorMaxLines: 2,
        errorStyle: const TextStyle(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: 11.8,
        ),
        prefixIcon: Icon(icon, color: primary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: primaryMid, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryMid, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryMid, width: 1.4),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedDialCode;
  final List<Map<String, String>> countryCodes;
  final ValueChanged<String> onChangedDialCode;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const _PhoneField({
    required this.controller,
    required this.selectedDialCode,
    required this.countryCodes,
    required this.onChangedDialCode,
    this.validator,
    this.onChanged,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color inputBg = Color(0xFFF2F5F4);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: validator,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: 'Enter your phone number',
        helperText: 'Choose country code, then enter the local number only',
        helperMaxLines: 2,
        errorMaxLines: 2,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        helperStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
          fontSize: 11.5,
        ),
        errorStyle: const TextStyle(
          color: primary,
          fontWeight: FontWeight.w700,
          fontSize: 11.8,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_outlined, color: primary, size: 20),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDialCode,
                  isDense: false,
                  isExpanded: false,
                  menuMaxHeight: 320,
                  borderRadius: BorderRadius.circular(16),
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: primary,
                  ),
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  items: countryCodes.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: SizedBox(
                        width: 150,
                        child: Text(
                          '${country['label']} ${country['code']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onChangedDialCode(value);
                    }
                  },
                ),
              ),
              Container(
                width: 1,
                height: 24,
                margin: const EdgeInsets.only(left: 8, right: 8),
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        filled: true,
        fillColor: inputBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: primaryMid, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryMid, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryMid, width: 1.4),
        ),
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
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    const double spacing = 72;
    const double shapeSize = 26;

    for (double y = 0; y < size.height + spacing; y += spacing) {
      for (double x = 0; x < size.width + spacing; x += spacing) {
        final path = Path();

        path.moveTo(x, y + shapeSize / 2);
        path.lineTo(x + shapeSize / 2, y);
        path.lineTo(x + shapeSize / 2, y + shapeSize);
        path.close();

        path.moveTo(x + shapeSize, y + shapeSize / 2);
        path.lineTo(x + shapeSize / 2, y);
        path.lineTo(x + shapeSize / 2, y + shapeSize);
        path.close();

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
