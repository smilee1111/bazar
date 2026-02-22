import 'package:flutter/material.dart';
import 'package:bazar/features/notification/presentation/widgets/notification_bell.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Image.asset(
          'assets/images/bazarlogo.png',
          height: 50,
          width: 50,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: const NotificationBell(),
        ),
      ],
    );
  }
}
