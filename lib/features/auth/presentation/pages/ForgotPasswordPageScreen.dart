import 'package:bazar/app/routes/app_routes.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/core/utils/snackbar_utils.dart';
import 'package:bazar/features/auth/presentation/pages/ResetPasswordPageScreen.dart';
import 'package:bazar/features/auth/presentation/state/auth_state.dart';
import 'package:bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordPageScreen extends ConsumerStatefulWidget {
  const ForgotPasswordPageScreen({super.key});

  @override
  ConsumerState<ForgotPasswordPageScreen> createState() =>
      _ForgotPasswordPageScreenState();
}

class _ForgotPasswordPageScreenState
    extends ConsumerState<ForgotPasswordPageScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetRequest() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(authViewModelProvider.notifier)
        .requestPasswordReset(email: _emailController.text.trim());
    if (!mounted) return;
    if (ok) {
      SnackbarUtils.showSuccess(
        context,
        'OTP sent to your email. Use it to reset your password.',
      );
      _openResetPage();
      return;
    }
    final err = ref.read(authViewModelProvider).errorMessage ?? 'Request failed';
    SnackbarUtils.showError(context, err);
  }

  void _openResetPage() {
    AppRoutes.push(
      context,
      ResetPasswordPageScreen(prefilledEmail: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your account email and we will send a reset OTP.',
                  style: AppTextStyle.minimalTexts.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@gmail.com',
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return 'Please enter your email';
                    if (!text.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : _sendResetRequest,
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send OTP'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _openResetPage,
                  child: Text(
                    'Already have OTP? Reset now',
                    style: AppTextStyle.minimalTexts.copyWith(
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
