import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _service = AuthService();

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool codeSent = false;
  bool isLoading = false;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  int seconds = 60;
  bool canResend = false;
  Timer? timer;

  String? emailServerError;
  String? codeServerError;
  String? passwordServerError;

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color errorRed = Color(0xFFB42318);
  static const Color accent = Color(0xFF16A085);
  static const Color cardBg = Color(0xFFF8FAFA);
  static const Color inputBg = Color(0xFFF2F5F4);

  @override
  void dispose() {
    timer?.cancel();
    emailController.dispose();
    codeController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  void clearServerErrors() {
    emailServerError = null;
    codeServerError = null;
    passwordServerError = null;
  }

  String friendlyErrorMessage(dynamic error, AppLocalizations l10n) {
    final raw = error.toString().replaceFirst('Exception: ', '');
    final message = raw.toLowerCase();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    String t(String ar, String en) => isArabic ? ar : en;

    if (message.contains('email') &&
        (message.contains('not found') || message.contains('not registered'))) {
      return t('البريد الإلكتروني غير مسجل.', 'This email is not registered.');
    }

    if (message.contains('failed to send code') ||
        message.contains('user not found') ||
        message.contains('not found') ||
        message.contains('not registered')) {
      return t('البريد الإلكتروني غير مسجل.', 'This email is not registered.');
    }

    if (message.contains('invalid') && message.contains('email')) {
      return t(
        'صيغة البريد الإلكتروني غير صحيحة.',
        'Please enter a valid email address.',
      );
    }

    if (message.contains('invalid') && message.contains('code')) {
      return t('رمز التحقق غير صحيح.', 'Invalid reset code.');
    }

    if (message.contains('expired') && message.contains('code')) {
      return t(
        'انتهت صلاحية رمز التحقق، أرسلي رمز جديد.',
        'Reset code has expired. Please resend a new code.',
      );
    }

    if (message.contains('network') ||
        message.contains('socketexception') ||
        message.contains('failed host lookup')) {
      return t(
        'تعذر الاتصال بالخادم. تأكدي من الإنترنت ثم حاولي مرة أخرى.',
        'Unable to connect to the server. Check your internet and try again.',
      );
    }

    if (message.contains('server error')) {
      return l10n.somethingWentWrong;
    }

    return t('حدث خطأ، حاولي مرة أخرى.', 'Something went wrong. Please try again.');
  }

  void applyServerErrorToField(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('email')) {
      emailServerError = message;
    } else if (lower.contains('code') || lower.contains('otp')) {
      codeServerError = message;
    } else if (lower.contains('password')) {
      passwordServerError = message;
    } else if (codeSent) {
      codeServerError = message;
    } else {
      emailServerError = message;
    }
  }

  String? validateEmail(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = (value ?? '').trim();

    if (text.isEmpty) return l10n.pleaseEnterEmail;
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(text)) {
      return l10n.pleaseEnterValidEmail;
    }

    return emailServerError;
  }

  String? validateCode(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = (value ?? '').trim();

    if (!codeSent) return null;
    if (text.isEmpty) return l10n.pleaseEnterResetCode;
    if (text.length != 6) return l10n.codeMustBe6Digits;

    return codeServerError;
  }

  String? validatePassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = value ?? '';

    if (!codeSent) return null;
    if (text.isEmpty) return l10n.pleaseEnterNewPassword;
    if (text.contains(' ')) return l10n.passwordNoSpaces;
    if (text.length < 8) return l10n.passwordTooShort;
    if (text.length > 20) return l10n.passwordTooLong;
    if (!RegExp(r'[A-Za-z]').hasMatch(text)) {
      return l10n.passwordNeedsLetter;
    }
    if (!RegExp(r'[0-9]').hasMatch(text)) {
      return l10n.passwordNeedsNumber;
    }

    return passwordServerError;
  }

  String? validateConfirmPassword(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final text = value ?? '';

    if (!codeSent) return null;
    if (text.isEmpty) return l10n.pleaseConfirmPassword;
    if (text != newPassController.text) return l10n.passwordsDoNotMatch;

    return null;
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      seconds = 60;
      canResend = false;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        if (mounted) {
          setState(() => canResend = true);
        }
      } else {
        if (mounted) {
          setState(() => seconds--);
        }
      }
    });
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
                  title: const Text("English"),
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

  Future<void> sendCode() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      clearServerErrors();
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      await _service.sendResetCode(emailController.text.trim());

      if (!mounted) return;

      setState(() {
        codeSent = true;
      });

      startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primary,
          content: Text(
            l10n.codeSentToYourEmail,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final message = friendlyErrorMessage(e, l10n);

      setState(() {
        clearServerErrors();
        emailServerError = message;
      });

      _formKey.currentState?.validate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: errorRed,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> resetPassword() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      clearServerErrors();
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      await _service.resetPassword(
        email: emailController.text.trim(),
        code: codeController.text.trim(),
        newPassword: newPassController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primary,
          content: Text(
            l10n.passwordChangedSuccessfully,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final message = friendlyErrorMessage(e, l10n);

      setState(() {
        clearServerErrors();
        applyServerErrorToField(message);
      });

      _formKey.currentState?.validate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: errorRed,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  InputDecoration inputStyle({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: primary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: inputBg,
      helperMaxLines: 2,
      errorMaxLines: 2,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      errorStyle: const TextStyle(
        color: errorRed,
        fontWeight: FontWeight.w700,
        fontSize: 11.8,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          l10n.forgotPasswordTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: IconButton(
              onPressed: _changeLanguage,
              icon: const Icon(Icons.language_rounded, color: Colors.white),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: _SoftPatternBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Container(
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
                      child: Column(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF4F2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              color: primary,
                              size: 34,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.resetPassword,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            codeSent
                                ? l10n.enterCodeAndCreateNewPassword
                                : l10n.enterEmailToReceiveResetCode,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.black.withOpacity(0.55),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),

                          _FieldLabel(l10n.email),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: emailController,
                            enabled: !codeSent,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) {
                              if (emailServerError != null) {
                                setState(() => emailServerError = null);
                              }
                            },
                            decoration: inputStyle(
                              hint: l10n.enterYourEmail,
                              icon: Icons.email_outlined,
                            ),
                          ),

                          if (codeSent) ...[
                            const SizedBox(height: 12),

                            _FieldLabel(l10n.verificationCode),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: codeController,
                              validator: validateCode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              textInputAction: TextInputAction.next,
                              onChanged: (_) {
                                if (codeServerError != null) {
                                  setState(() => codeServerError = null);
                                }
                              },
                              decoration: inputStyle(
                                hint: l10n.enter6DigitCode,
                                icon: Icons.pin_outlined,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: GestureDetector(
                                onTap: canResend && !isLoading
                                    ? () {
                                        sendCode();
                                      }
                                    : null,
                                child: Text(
                                  canResend
                                      ? l10n.resendCode
                                      : l10n.resendInSeconds(seconds),
                                  style: TextStyle(
                                    color: canResend ? primary : Colors.grey,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            _FieldLabel(l10n.newPassword),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: newPassController,
                              obscureText: obscureNewPassword,
                              validator: validatePassword,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) {
                                if (passwordServerError != null) {
                                  setState(() => passwordServerError = null);
                                }
                              },
                              decoration: inputStyle(
                                hint: l10n.enterNewPassword,
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureNewPassword = !obscureNewPassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscureNewPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            _FieldLabel(l10n.confirmPassword),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: confirmPassController,
                              obscureText: obscureConfirmPassword,
                              validator: validateConfirmPassword,
                              textInputAction: TextInputAction.done,
                              decoration: inputStyle(
                                hint: l10n.reEnterNewPassword,
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureConfirmPassword =
                                          !obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey.shade500,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : codeSent
                                      ? resetPassword
                                      : sendCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                disabledBackgroundColor: primaryMid,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      codeSent
                                          ? l10n.resetPassword
                                          : l10n.sendCode,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          ),

                          if (codeSent) ...[
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      timer?.cancel();
                                      setState(() {
                                        codeSent = false;
                                        canResend = false;
                                        seconds = 60;
                                        codeController.clear();
                                        newPassController.clear();
                                        confirmPassController.clear();
                                        clearServerErrors();
                                      });
                                    },
                              child: Text(
                                l10n.changeEmail,
                                style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
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