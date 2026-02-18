import 'package:bazar/screens/FavouriteScreen.dart';
import 'package:bazar/features/dashboard/presentation/pages/HomeScreen.dart';
import 'package:bazar/features/auth/presentation/pages/ProfileScreen.dart';
import 'package:bazar/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:bazar/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:bazar/screens/SavedScreen.dart';
import 'package:flutter/material.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const Homescreen(),
    const Savedscreen(),
    const Favouritescreen(),
    const Profilescreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(),
      body: IndexedStack(index: _selectedIndex, children: lstBottomScreen),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
