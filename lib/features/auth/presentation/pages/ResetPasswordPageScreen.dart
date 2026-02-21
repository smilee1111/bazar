import 'package:bazar/app/routes/app_routes.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/core/utils/snackbar_utils.dart';
import 'package:bazar/features/auth/presentation/pages/LoginPageScreen.dart';
import 'package:bazar/features/auth/presentation/state/auth_state.dart';
import 'package:bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordPageScreen extends ConsumerStatefulWidget {
  const ResetPasswordPageScreen({super.key, this.prefilledEmail});

  final String? prefilledEmail;

  @override
  ConsumerState<ResetPasswordPageScreen> createState() =>
      _ResetPasswordPageScreenState();
}

class _ResetPasswordPageScreenState
    extends ConsumerState<ResetPasswordPageScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.prefilledEmail ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await ref.read(authViewModelProvider.notifier).verifyResetOtp(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
      newPassword: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;
    if (!ok) {
      final err =
          ref.read(authViewModelProvider).errorMessage ??
          'Invalid OTP or OTP expired';
      SnackbarUtils.showError(context, err);
      return;
    }

    SnackbarUtils.showSuccess(context, 'Password reset successful. Please login.');
    AppRoutes.pushAndRemoveUntil(context, const Loginpagescreen());
  }

  Future<void> _resendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      SnackbarUtils.showError(context, 'Enter a valid email first');
      return;
    }
    final ok = await ref
        .read(authViewModelProvider.notifier)
        .requestPasswordReset(email: email);
    if (!mounted) return;
    if (ok) {
      SnackbarUtils.showSuccess(context, 'OTP resent to your email');
      return;
    }
    final err = ref.read(authViewModelProvider).errorMessage ?? 'Failed to resend OTP';
    SnackbarUtils.showError(context, err);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((widget.prefilledEmail ?? '').isNotEmpty) ...[
                  Text(
                    'Resetting password for: ${widget.prefilledEmail}',
                    style: AppTextStyle.minimalTexts.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  'Enter your email, OTP, and your new password to continue.',
                  style: AppTextStyle.minimalTexts.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@gmail.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Email is required';
                    }
                    if (!text.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    hintText: 'Enter OTP from email',
                    prefixIcon: Icon(Icons.lock_clock_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'OTP is required';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: authState.status == AuthStatus.loading
                        ? null
                        : _resendOtp,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      'Resend OTP',
                      style: AppTextStyle.minimalTexts.copyWith(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
