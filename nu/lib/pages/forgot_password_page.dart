import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
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

  String? validateEmail(String? value) {
    final text = (value ?? '').trim();

    if (text.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(text)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? validateCode(String? value) {
    final text = (value ?? '').trim();

    if (!codeSent) return null;
    if (text.isEmpty) return 'Please enter the reset code';
    if (text.length != 6) return 'Code must be 6 digits';

    return null;
  }

  String? validatePassword(String? value) {
    final text = value ?? '';

    if (!codeSent) return null;
    if (text.isEmpty) return 'Please enter your new password';
    if (text.contains(' ')) return 'Password must not contain spaces';
    if (text.length < 8) return 'Password must be at least 8 characters';
    if (text.length > 20) return 'Password must not exceed 20 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(text)) {
      return 'Password must contain at least one letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(text)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    final text = value ?? '';

    if (!codeSent) return null;
    if (text.isEmpty) return 'Please confirm your password';
    if (text != newPassController.text) return 'Passwords do not match';

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

  Future<void> sendCode() async {
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
        const SnackBar(
          backgroundColor: primary,
          content: Text(
            'Code sent to your email',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryMid,
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
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
        const SnackBar(
          backgroundColor: primary,
          content: Text(
            'Password changed successfully',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryMid,
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
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
        color: primary,
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
        borderSide: const BorderSide(color: primaryMid, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryMid, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
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
                          const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            codeSent
                                ? 'Enter the code sent to your email and create a new password'
                                : 'Enter your email to receive a password reset code',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.black.withOpacity(0.55),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 18),

                          _FieldLabel('Email'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: emailController,
                            enabled: !codeSent,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                            textInputAction: TextInputAction.next,
                            decoration: inputStyle(
                              hint: 'Enter your email',
                              icon: Icons.email_outlined,
                            ),
                          ),

                          if (codeSent) ...[
                            const SizedBox(height: 12),

                            _FieldLabel('Verification Code'),
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
                              decoration: inputStyle(
                                hint: 'Enter 6-digit code',
                                icon: Icons.pin_outlined,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: canResend && !isLoading
                                    ? () {
                                        sendCode();
                                      }
                                    : null,
                                child: Text(
                                  canResend
                                      ? 'Resend Code'
                                      : 'Resend in $seconds s',
                                  style: TextStyle(
                                    color: canResend ? primary : Colors.grey,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            _FieldLabel('New Password'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: newPassController,
                              obscureText: obscureNewPassword,
                              validator: validatePassword,
                              textInputAction: TextInputAction.next,
                              decoration: inputStyle(
                                hint: 'Enter new password',
                                icon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureNewPassword =
                                          !obscureNewPassword;
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

                            _FieldLabel('Confirm Password'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: confirmPassController,
                              obscureText: obscureConfirmPassword,
                              validator: validateConfirmPassword,
                              textInputAction: TextInputAction.done,
                              decoration: inputStyle(
                                hint: 'Re-enter new password',
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
                                          ? 'Reset Password'
                                          : 'Send Code',
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
                                      });
                                    },
                              child: const Text(
                                'Change email',
                                style: TextStyle(
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