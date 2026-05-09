import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_dashboard_page.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import 'signup_page.dart';
import 'provider_home_screen.dart';
import 'pilgrim_home_screen.dart';
import '../services/auth_service.dart';
import '../session/user_session.dart';
import 'forgot_password_page.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _submittedOnce = false;

  String? _generalError;
  String? _idServerError;
  String? _passwordServerError;

  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color errorRed = Color(0xFFB42318);
  static const Color errorBg = Color(0xFFFFF1F0);
  static const Color accent = Color(0xFF16A085);
  static const Color cardBg = Color(0xFFF8FAFA);
  static const Color inputBg = Color(0xFFF2F5F4);

  static const Color infoBg = Color(0xFFEAF4F2);
  static const Color infoBorder = Color(0xFF9CC8C0);
  static const Color infoText = Color(0xFF0D4C4A);

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateId(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = (value ?? '').trim();

    if (text.isEmpty) return l10n.pleaseEnterYourId;
    if (text.contains(' ')) return l10n.idMustNotContainSpaces;
    if (!RegExp(r'^[0-9]+$').hasMatch(text)) {
      return l10n.idNumbersOnly;
    }
    if (text.length < 6) return l10n.idTooShort;
    if (text.length > 20) return l10n.idTooLong;

    return _idServerError;
  }

  String? _validatePassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = value ?? '';

    if (text.isEmpty) return l10n.pleaseEnterPassword;
    if (text.contains(' ')) return l10n.passwordNoSpaces;
    if (text.length < 8) return l10n.passwordTooShort;
    if (text.length > 20) return l10n.passwordTooLong;

    return _passwordServerError;
  }

  String _friendlyErrorMessage(String error, AppLocalizations l10n) {
    final message = error.toLowerCase();

    if (message.contains('invalid credentials')) {
      return l10n.incorrectIdOrPassword;
    }

    if (message.contains('id and password are required')) {
      return l10n.enterBothIdAndPassword;
    }

    if (message.contains('network') ||
        message.contains('socketexception') ||
        message.contains('failed host lookup')) {
      return l10n.unableToConnectToServer;
    }

    if (message.contains('server error')) {
      return l10n.somethingWentWrongDuringLogin;
    }

    return error;
  }

  Future<void> _changeLanguage() async {
    final currentLocale = Localizations.localeOf(context).languageCode;

    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l10n.chooseLanguage,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text(l10n.arabic),
                  trailing: currentLocale == "ar"
                      ? const Icon(Icons.check, color: primary)
                      : null,
                  onTap: () => Navigator.pop(context, "ar"),
                ),
                ListTile(
                  title: Text(l10n.english),
                  trailing: currentLocale == "en"
                      ? const Icon(Icons.check, color: primary)
                      : null,
                  onTap: () => Navigator.pop(context, "en"),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      NusuqApp.of(context).setLocale(Locale(selected));
    }
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _submittedOnce = true;
      _generalError = null;
      _idServerError = null;
      _passwordServerError = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = await _authService.login(
        id: _idController.text.trim(),
        password: _passwordController.text,
      );

      UserSession.setUser(
        id: _idController.text.trim(),
        name: user.fullName,
        userEmail: user.email,
        userPhone: user.phoneNumber,
        userRole: user.role,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primary,
          content: Text(
            l10n.loginSuccessful,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      if (user.role == 'provider') {
        Navigator.pushReplacementNamed(context, ProviderHomeScreen.routeName);
      } else if (user.role == 'admin') {
        Navigator.pushReplacementNamed(context, AdminDashboardPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, PilgrimHomeScreen.routeName);
      }
    } catch (e) {
      if (!mounted) return;

      final errorMessage = _friendlyErrorMessage(
        e.toString().replaceFirst('Exception: ', ''),
        l10n,
      );

      setState(() {
        _generalError = errorMessage;
        _idServerError = errorMessage;
        _passwordServerError = errorMessage;
      });

      _formKey.currentState?.validate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: errorRed,
          content: Text(
            errorMessage,
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
    final l10n = AppLocalizations.of(context)!;

    final autoValidateMode = _submittedOnce
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Scaffold(
      backgroundColor: primaryDark,
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftPatternBackground()),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            l10n.smartPlatformForServingPilgrims,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
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
                              Text(
                                l10n.logIn,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.enterIdAndPassword,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.black.withOpacity(0.55),
                                  fontWeight: FontWeight.w600,
                                ),
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
                                    color: errorBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: errorRed),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: errorRed,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _generalError!,
                                          style: const TextStyle(
                                            color: errorRed,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              _FieldLabel(l10n.idNumber),
                              const SizedBox(height: 6),
                              _AppField(
                                controller: _idController,
                                hintText: l10n.enterYourIdNumber,
                                helperText: l10n.idNumberHelper,
                                icon: Icons.badge_outlined,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: _validateId,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(20),
                                ],
                                onChanged: (_) {
                                  if (_generalError != null ||
                                      _idServerError != null ||
                                      _passwordServerError != null) {
                                    setState(() {
                                      _generalError = null;
                                      _idServerError = null;
                                      _passwordServerError = null;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              _FieldLabel(l10n.password),
                              const SizedBox(height: 6),
                              _AppField(
                                controller: _passwordController,
                                hintText: l10n.enterYourPassword,
                                helperText: l10n.loginPasswordHelper,
                                icon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
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
                                  if (_generalError != null ||
                                      _idServerError != null ||
                                      _passwordServerError != null) {
                                    setState(() {
                                      _generalError = null;
                                      _idServerError = null;
                                      _passwordServerError = null;
                                    });
                                  }
                                },
                              ),

                              const SizedBox(height: 8),

                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ForgotPasswordPage.routeName,
                                    );
                                  },
                                  child: Text(
                                    l10n.forgotPassword,
                                    style: const TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
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
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              l10n.logIn,
                                              style: const TextStyle(
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
                                    l10n.dontHaveAccount,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        SignUpScreen.routeName,
                                      );
                                    },
                                    child: Text(
                                      l10n.createAccount,
                                      style: const TextStyle(
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
                        l10n.nusuqCopyright,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.integratedSystemForServingPilgrims,
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

          Positioned(
            top: 14,
            right: 14,
            child: SafeArea(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: IconButton(
                  onPressed: _changeLanguage,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.14),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.white.withOpacity(0.18)),
                    ),
                  ),
                  icon: const Icon(Icons.language_rounded),
                ),
              ),
            ),
          ),
        ],
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
      alignment: AlignmentDirectional.centerStart,
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
  static const Color errorRed = Color(0xFFB42318);
  static const Color errorBg = Color(0xFFFFF1F0);
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
        errorMaxLines: 2,
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
          color: errorRed,
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
          borderSide: const BorderSide(color: errorRed, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed, width: 1.4),
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
