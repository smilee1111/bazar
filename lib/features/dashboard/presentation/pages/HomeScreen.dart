import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/features/dashboard/presentation/widgets/public_shop_card.dart';
import 'package:bazar/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:bazar/features/savedShop/presentation/view_model/saved_shop_view_model.dart';
import 'package:bazar/features/shop/presentation/pages/shop_public_detail_page.dart';
import 'package:bazar/features/shop/presentation/view_model/shop_view_model.dart';
import 'package:bazar/features/shopReview/presentation/view_model/user_review_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(shopViewModelProvider.notifier).loadPublicShops();
      ref.read(savedShopViewModelProvider.notifier).loadSavedShops();
      ref.read(favouriteViewModelProvider.notifier).loadFavourites();
      ref.read(userReviewViewModelProvider.notifier).loadReviewedShops();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopViewModelProvider);
    final savedState = ref.watch(savedShopViewModelProvider);
    final favouriteState = ref.watch(favouriteViewModelProvider);
    final userReviewState = ref.watch(userReviewViewModelProvider);
    final reviewedIds = {
      ...userReviewState.reviewedShopIds,
      ...favouriteState.reviewedShopIds,
    };
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? shopState.publicShops
        : shopState.publicShops.where((shop) {
            return shop.shopName.toLowerCase().contains(query) ||
                shop.shopAddress.toLowerCase().contains(query) ||
                shop.shopContact.toLowerCase().contains(query);
          }).toList();

    final isLoadingInitial =
        shopState.isLoadingPublic && !shopState.hasLoadedPublic;

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref
                .read(shopViewModelProvider.notifier)
                .loadPublicShops(forceRefresh: true),
            ref
                .read(savedShopViewModelProvider.notifier)
                .loadSavedShops(forceRefresh: true),
            ref
                .read(favouriteViewModelProvider.notifier)
                .loadFavourites(forceRefresh: true),
            ref
                .read(userReviewViewModelProvider.notifier)
                .loadReviewedShops(forceRefresh: true),
          ]);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: _TopBanner(
                  searchCtrl: _searchCtrl,
                  onQueryChanged: () {
                    setState(() {});
                  },
                  onClear: () {
                    setState(() {
                      _searchCtrl.clear();
                    });
                  },
                ),
              ),
            ),
            if (isLoadingInitial)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.builder(
                  itemCount: 6,
                  itemBuilder: (_, _) => const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: _ShopSkeletonCard(),
                  ),
                ),
              )
            else if ((shopState.errorMessage ?? '').isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _StatusCard(
                    message: shopState.errorMessage!,
                    isError: true,
                  ),
                ),
              )
            else if (filtered.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                  child: _EmptyState(
                    query: query,
                    onClear: () {
                      setState(() {
                        _searchCtrl.clear();
                      });
                    },
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                sliver: SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final shop = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PublicShopCard(
                        shop: shop,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShopPublicDetailPage(shop: shop),
                            ),
                          );
                        },
                        isSaved: savedState.savedShopIds.contains(
                          shop.shopId ?? '',
                        ),
                        isFavourite: favouriteState.favouriteShopIds.contains(
                          shop.shopId ?? '',
                        ),
                        isReviewed: reviewedIds.contains(
                          shop.shopId ?? '',
                        ),
                        isSaveBusy: savedState.processingShopIds.contains(
                          shop.shopId ?? '',
                        ),
                        isFavouriteBusy: favouriteState.processingShopIds.contains(
                          shop.shopId ?? '',
                        ),
                        onToggleSave: () {
                          final shopId = shop.shopId ?? '';
                          if (shopId.isEmpty) return;
                          ref
                              .read(savedShopViewModelProvider.notifier)
                              .toggleSaved(shopId);
                        },
                        onToggleFavourite: () {
                          final shopId = shop.shopId ?? '';
                          if (shopId.isEmpty) return;
                          final isReviewed = reviewedIds.contains(shopId);
                          ref
                              .read(favouriteViewModelProvider.notifier)
                              .toggleFavourite(
                                shopId: shopId,
                                isReviewed: isReviewed ? true : null,
                              );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  const _TopBanner({
    required this.searchCtrl,
    required this.onQueryChanged,
    required this.onClear,
  });
  final TextEditingController searchCtrl;
  final VoidCallback onQueryChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover Shops',
            style: AppTextStyle.inputBox.copyWith(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Browse verified shops and explore what they offer.',
            style: AppTextStyle.minimalTexts.copyWith(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchCtrl,
            onChanged: (_) => onQueryChanged(),
            style: AppTextStyle.inputBox.copyWith(
              fontSize: 13,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Search shops by name, address or phone',
              hintStyle: AppTextStyle.minimalTexts.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
              ),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white),
              suffixIcon: searchCtrl.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.error : AppColors.info;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        message,
        style: AppTextStyle.inputBox.copyWith(fontSize: 13, color: color),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent2),
      ),
      child: Column(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.accent2.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.store_mall_directory_outlined,
              size: 34,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            query.isEmpty ? 'No shops available' : 'No results found',
            style: AppTextStyle.inputBox.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            query.isEmpty
                ? 'Pull down to refresh and check again.'
                : 'Try another keyword or clear search.',
            textAlign: TextAlign.center,
            style: AppTextStyle.minimalTexts.copyWith(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          if (query.isNotEmpty) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ShopSkeletonCard extends StatelessWidget {
  const _ShopSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _SkeletonLine(widthFactor: 0.55, height: 14),
          SizedBox(height: 10),
          _SkeletonLine(widthFactor: 0.95, height: 11),
          SizedBox(height: 6),
          _SkeletonLine(widthFactor: 0.8, height: 11),
          SizedBox(height: 12),
          _SkeletonLine(widthFactor: 0.4, height: 11),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFEAE7DE),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
