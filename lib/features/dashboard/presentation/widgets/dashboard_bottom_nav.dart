import 'package:flutter/material.dart';

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showSellerTab = false,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool showSellerTab;

  @override
  Widget build(BuildContext context) {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      if (showSellerTab)
        const BottomNavigationBarItem(
          icon: Icon(Icons.storefront_outlined),
          label: 'Shop',
        ),
      const BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.star),
        label: 'Favourites',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    return BottomNavigationBar(
      iconSize: 40,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
