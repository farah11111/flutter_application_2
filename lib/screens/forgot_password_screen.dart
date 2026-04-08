import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart' as ap;
import '../../utils/app_theme.dart';
import '../../widgets/aegis_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sent = false;
  bool _loading = false;

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final provider = Provider.of<ap.AuthProvider>(context, listen: false);
    final success = await provider.sendPasswordReset(_emailController.text);
    setState(() {
      _loading = false;
      _sent = success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AegisNavBar(showAuthButtons: false),
      body: AegisBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 440),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.inputBorder, width: 0.5),
                gradient: AppColors.cardGradient,
              ),
              padding: const EdgeInsets.all(36),
              child: _sent ? _buildSuccess() : _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border:
                  Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.lock_reset_rounded,
                color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 20),
          Text('Reset Password',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text(
            "Enter your email address and we'll send you a link to reset your password.",
            textAlign: TextAlign.center,
            style:
                TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 28),
          AegisTextField(
            label: 'Email Address',
            hintText: 'your.email@example.com',
            prefixIcon: Icons.mail_outline_rounded,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onEditingComplete: _handleReset,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Email is required';
              if (!val.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 24),
          AegisGradientButton(
            text: 'Send Reset Link',
            isLoading: _loading,
            onPressed: _handleReset,
            icon: Icons.send_rounded,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
            border:
                Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.success, size: 36),
        ),
        const SizedBox(height: 20),
        Text('Email Sent!',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text(
          'A password reset link has been sent to\n${_emailController.text}',
          textAlign: TextAlign.center,
          style:
              const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 28),
        AegisGradientButton(
          text: 'Back to Login',
          onPressed: () => Navigator.pop(context),
          icon: Icons.login_rounded,
        ),
      ],
    );
  }
}
