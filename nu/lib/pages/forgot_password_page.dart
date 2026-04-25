import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthService _service = AuthService();

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPassController = TextEditingController();

  bool codeSent = false;

  void sendCode() async {
    await _service.sendResetCode(emailController.text);
    setState(() => codeSent = true);
  }

  void resetPassword() async {
    await _service.resetPassword(
      email: emailController.text,
      code: codeController.text,
      newPassword: newPassController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(hintText: 'Email')),

            if (codeSent) ...[
              TextField(controller: codeController, decoration: const InputDecoration(hintText: 'Code')),
              TextField(controller: newPassController, decoration: const InputDecoration(hintText: 'New Password')),
            ],

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: codeSent ? resetPassword : sendCode,
              child: Text(codeSent ? 'Reset Password' : 'Send Code'),
            )
          ],
        ),
      ),
    );
  }
}