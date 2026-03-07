import 'package:flutter/material.dart';
import 'signup_page.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  static const Color primaryDark = Color(0xFF062C26);
  static const Color primary = Color(0xFF0D4C4A);
  static const Color primaryMid = Color(0xFF1A6B66);
  static const Color accent = Color(0xFF16A085);
  static const Color mint = Color(0xFF9FE5C9);
  static const Color cardBg = Color(0xFFF8FAFA);
  static const Color inputBg = Color(0xFFF2F5F4);

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credentials verified successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          color: Colors.white.withOpacity(0.78),
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
                      child: Column(
                        children: [
                          const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enter your credentials to access your account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.black.withOpacity(0.55),
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 16),

                          _FieldLabel('ID Number'),
                          const SizedBox(height: 6),
                          _AppField(
                            controller: _idController,
                            hintText: 'Enter your ID number',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your ID number';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          _FieldLabel('Password'),
                          const SizedBox(height: 6),
                          _AppField(
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your password';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Transform.scale(
                                scale: 0.95,
                                child: Checkbox(
                                  value: _rememberMe,
                                  activeColor: accent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Log In',
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
                                'Don’t have an account? ',
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
                                child: const Text(
                                  'Create account',
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
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AppField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  static const Color primary = Color(0xFF0D4C4A);
  static const Color inputBg = Color(0xFFF2F5F4);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w600,
          fontSize: 13,
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
          borderSide: BorderSide(color: primary, width: 1.4),
        ),
      ),
    );
  }
}

class _SoftPatternBackground extends StatelessWidget {
  const _SoftPatternBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SoftPatternPainter(),
    );
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