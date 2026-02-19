import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/core/utils/snackbar_utils.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/presentation/pages/shop_form_page.dart';
import 'package:bazar/features/shop/presentation/pages/shop_public_detail_page.dart';
import 'package:bazar/features/shop/presentation/view_model/shop_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerShopPage extends ConsumerStatefulWidget {
  const SellerShopPage({super.key});

  @override
  ConsumerState<SellerShopPage> createState() => _SellerShopPageState();
}

class _SellerShopPageState extends ConsumerState<SellerShopPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(shopViewModelProvider.notifier).loadSellerShops();
    });
  }

  Future<void> _openForm({ShopEntity? shop}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShopFormPage(initialShop: shop)),
    );
    if (!mounted) return;
    await ref
        .read(shopViewModelProvider.notifier)
        .loadSellerShops(forceRefresh: true);
  }

  Future<void> _openContentManager(ShopEntity shop) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopPublicDetailPage(shop: shop, allowOwnerEdit: true),
      ),
    );
  }

  Future<void> _deleteShop(String shopId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete shop'),
        content: const Text('Are you sure you want to delete this shop?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    final ok = await ref
        .read(shopViewModelProvider.notifier)
        .deleteShop(shopId);
    if (!mounted) return;
    if (ok) {
      SnackbarUtils.showSuccess(context, 'Shop deleted');
    } else {
      final err =
          ref.read(shopViewModelProvider).errorMessage ?? 'Delete failed';
      SnackbarUtils.showError(context, err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopViewModelProvider);
    final myShop = state.myShop;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(shopViewModelProvider.notifier)
              .loadSellerShops(forceRefresh: true);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Manage Shop',
                    style: AppTextStyle.inputBox.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add_business_outlined, size: 18),
                  label: const Text('Create'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 42),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Create, update and maintain your seller shop details.',
              style: AppTextStyle.minimalTexts.copyWith(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            if (state.isLoadingSeller && !state.hasLoadedSeller)
              const Center(child: CircularProgressIndicator())
            else ...[
              if ((state.errorMessage ?? '').isNotEmpty) ...[
                _InfoBanner(message: state.errorMessage!, isError: true),
                const SizedBox(height: 12),
              ],
              if (myShop != null) ...[
                _SectionTitle(title: 'My Shop'),
                _ShopCard(
                  shop: myShop,
                  onEdit: () => _openForm(shop: myShop),
                  onManageContent: () => _openContentManager(myShop),
                  onDelete: myShop.shopId == null
                      ? null
                      : () => _deleteShop(myShop.shopId!),
                ),
                const SizedBox(height: 14),
              ],
              if (myShop == null) ...[
                _SectionTitle(title: 'My Shop'),
                _InfoBanner(
                  message: 'No shop found. Create your shop to start selling.',
                  isError: false,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyle.inputBox.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message, required this.isError});
  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isError ? AppColors.error : AppColors.info).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? AppColors.error : AppColors.info,
          width: 0.8,
        ),
      ),
      child: Text(
        message,
        style: AppTextStyle.inputBox.copyWith(
          fontSize: 13,
          color: isError ? AppColors.error : AppColors.info,
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({
    required this.shop,
    required this.onEdit,
    required this.onManageContent,
    required this.onDelete,
  });

  final ShopEntity shop;
  final VoidCallback onEdit;
  final VoidCallback onManageContent;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  shop.shopName,
                  style: AppTextStyle.inputBox.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit shop',
              ),
              IconButton(
                onPressed: onManageContent,
                icon: const Icon(Icons.photo_library_outlined),
                tooltip: 'Manage details/photos/reviews',
              ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: 'Delete shop',
                ),
            ],
          ),
          const SizedBox(height: 6),
          _MiniRow(icon: Icons.location_on_outlined, value: shop.shopAddress),
          _MiniRow(icon: Icons.phone_outlined, value: shop.shopContact),
          if ((shop.email ?? '').isNotEmpty)
            _MiniRow(icon: Icons.mail_outline_rounded, value: shop.email!),
          if ((shop.description ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                shop.description!,
                style: AppTextStyle.minimalTexts.copyWith(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.inputBox.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
