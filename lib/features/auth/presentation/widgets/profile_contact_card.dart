import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bazar/core/utils/snackbar_utils.dart';

class ProfileContactCard extends ConsumerStatefulWidget {
  const ProfileContactCard({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.fullName,
    required this.username,
  });

  final String phoneNumber;
  final String email;
  final String fullName;
  final String username;

  @override
  ConsumerState<ProfileContactCard> createState() => _ProfileContactCardState();
}

class _ProfileContactCardState extends ConsumerState<ProfileContactCard> {
  bool _isSaving = false;

  void _showEditDialog() {
    final fullNameCtrl = TextEditingController(text: widget.fullName);
    final emailCtrl = TextEditingController(text: widget.email);
    final phoneCtrl = TextEditingController(text: widget.phoneNumber);
    final usernameCtrl = TextEditingController(text: widget.username);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx2).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text('Edit Profile', style: AppTextStyle.inputBox.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('Update your display name, contact and username', style: AppTextStyle.minimalTexts.copyWith(color: Colors.grey.shade600)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fullNameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.alternate_email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter username' : null,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  Navigator.of(ctx2).pop();
                                },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  // set loading states
                                  setState(() => _isSaving = true);
                                  setSheetState(() {});
                                  final success = await ref.read(authViewModelProvider.notifier).updateProfile(
                                    fullName: fullNameCtrl.text.trim(),
                                    email: emailCtrl.text.trim(),
                                    phoneNumber: phoneCtrl.text.trim(),
                                    username: usernameCtrl.text.trim(),
                                  );
                                  setState(() => _isSaving = false);
                                  setSheetState(() {});
                                  Navigator.of(ctx2).pop();
                                  if (success) {
                                    if (mounted) {
                                      SnackbarUtils.showSuccess(context, 'Profile updated');
                                    }
                                  } else {
                                    if (mounted) {
                                      SnackbarUtils.showError(context, 'Failed to update profile');
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _isSaving
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.fullName, style: AppTextStyle.inputBox.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text('@${widget.username}', style: AppTextStyle.minimalTexts.copyWith(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showEditDialog,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _ContactRow(
            label: 'Phone',
            value: widget.phoneNumber,
            icon: Icons.phone_rounded,
          ),
          const SizedBox(height: 18),
          _ContactRow(
            label: 'Mail',
            value: widget.email,
            icon: Icons.mail_outline_rounded,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2EFE3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.brown.shade700),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.minimalTexts.copyWith(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: AppTextStyle.inputBox.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
