import 'package:bazar/screens/FavouriteScreen.dart';
import 'package:bazar/core/services/storage/user_session_service.dart';
import 'package:bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:bazar/features/dashboard/presentation/pages/HomeScreen.dart';
import 'package:bazar/features/auth/presentation/pages/ProfileScreen.dart';
import 'package:bazar/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:bazar/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:bazar/features/role/domain/usecases/get_all_role_usecase.dart';
import 'package:bazar/features/shop/presentation/pages/seller_shop_page.dart';
import 'package:bazar/screens/SavedScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboardscreen extends ConsumerStatefulWidget {
  const Dashboardscreen({super.key});

  @override
  ConsumerState<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends ConsumerState<Dashboardscreen> {
  int _selectedIndex = 0;
  bool _sellerAccessFromSession = false;
  bool _didResolveSellerAccess = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authViewModelProvider);
      if (authState.user == null) {
        ref.read(authViewModelProvider.notifier).getCurrentUser();
      }
      _resolveSellerAccessFromSession();
    });
  }

  List<Widget> _buildScreens(bool showSellerTab) {
    return [
      const Homescreen(),
      if (showSellerTab) const SellerShopPage(),
      const Savedscreen(),
      const Favouritescreen(),
      const Profilescreen(),
    ];
  }

  Future<void> _resolveSellerAccessFromSession() async {
    final roleId = ref.read(userSessionServiceProvider).getCurrentUserRoleId();
    if (roleId == null || roleId.isEmpty) {
      if (!mounted) return;
      setState(() {
        _sellerAccessFromSession = false;
        _didResolveSellerAccess = true;
      });
      return;
    }

    final result = await ref.read(getAllRoleUseCaseProvider)();
    if (!mounted) return;
    result.fold(
      (_) {
        setState(() {
          _sellerAccessFromSession = false;
          _didResolveSellerAccess = true;
        });
      },
      (roles) {
        final matched = roles.where((role) => role.roleId == roleId).toList();
        final isSeller = (matched.isNotEmpty &&
                matched.first.roleName.toLowerCase() == 'seller') ||
            roleId.toLowerCase().contains('seller');
        setState(() {
          _sellerAccessFromSession = isSeller;
          _didResolveSellerAccess = true;
        });
      },
    );
  }

  bool _isSeller() {
    final roleName = ref.watch(authViewModelProvider).user?.role?.roleName;
    if (roleName != null && roleName.toLowerCase() == 'seller') {
      return true;
    }
    if (!_didResolveSellerAccess) {
      return false;
    }
    return _sellerAccessFromSession;
  }

  @override
  Widget build(BuildContext context) {
    final showSellerTab = _isSeller();
    final screens = _buildScreens(showSellerTab);
    if (_selectedIndex >= screens.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      appBar: const DashboardAppBar(),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: _selectedIndex,
        showSellerTab: showSellerTab,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
