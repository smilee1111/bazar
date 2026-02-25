import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/category/domain/usecases/get_all_category_usecase.dart';
import 'package:bazar/features/dashboard/presentation/view_model/shop_card_preview_provider.dart';
import 'package:bazar/features/dashboard/presentation/widgets/public_shop_card.dart';
import 'package:bazar/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:bazar/features/savedShop/presentation/view_model/saved_shop_view_model.dart';
import 'package:bazar/features/sensor/presentation/state/sensor_state.dart';
import 'package:bazar/features/sensor/presentation/view_model/sensor_view_model.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
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
  List<CategoryEntity> _categories = const [];
  bool _isLoadingCategories = false;
  _ShopFilters _filters = const _ShopFilters();
  DateTime? _lastShakeRefreshAt;
  SensorViewModel? _sensorViewModel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(shopViewModelProvider.notifier).loadPublicShops();
      ref.read(savedShopViewModelProvider.notifier).loadSavedShops();
      ref.read(favouriteViewModelProvider.notifier).loadFavourites();
      ref.read(userReviewViewModelProvider.notifier).loadReviewedShops();
      _sensorViewModel = ref.read(sensorViewModelProvider.notifier);
      _sensorViewModel?.attach();
      _loadCategories();
    });
  }

  @override
  void dispose() {
    _sensorViewModel?.detach();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _refreshFeeds({bool forceRefresh = true}) async {
    await Future.wait([
      ref
          .read(shopViewModelProvider.notifier)
          .loadPublicShops(forceRefresh: forceRefresh),
      ref
          .read(savedShopViewModelProvider.notifier)
          .loadSavedShops(forceRefresh: forceRefresh),
      ref
          .read(favouriteViewModelProvider.notifier)
          .loadFavourites(forceRefresh: forceRefresh),
      ref
          .read(userReviewViewModelProvider.notifier)
          .loadReviewedShops(forceRefresh: forceRefresh),
    ]);
  }

  Future<void> _onShakeDetected() async {
    final now = DateTime.now();
    if (_lastShakeRefreshAt != null &&
        now.difference(_lastShakeRefreshAt!) < const Duration(seconds: 3)) {
      return;
    }
    _lastShakeRefreshAt = now;
    await _refreshFeeds();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });
    final result = await ref.read(getAllCategoryUseCaseProvider)();
    if (!mounted) return;
    result.fold(
      (_) {
        setState(() {
          _categories = const [];
          _isLoadingCategories = false;
        });
      },
      (items) {
        setState(() {
          _categories = items;
          _isLoadingCategories = false;
        });
      },
    );
  }

  Future<void> _openFilters() async {
    final selected = _filters;
    String? selectedCategory = selected.categoryName;
    final locationCtrl = TextEditingController(text: selected.locationQuery);
    int selectedMinRating = selected.minRating.round();
    PriceFilter selectedPrice = selected.priceFilter;

    final applied = await showModalBottomSheet<_ShopFilters>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 46,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.accent2,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Filter Shops',
                      style: AppTextStyle.inputBox.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Refine by category, location, price and rating.',
                      style: AppTextStyle.minimalTexts.copyWith(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Category',
                      style: AppTextStyle.inputBox.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String?>(
                      initialValue: selectedCategory,
                      style: AppTextStyle.inputBox.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            'Any category',
                            style: AppTextStyle.inputBox.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ..._categories.map(
                          (item) => DropdownMenuItem<String?>(
                            value: item.categoryName,
                            child: Text(
                              item.categoryName,
                              style: AppTextStyle.inputBox.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(() => selectedCategory = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Location',
                      style: AppTextStyle.inputBox.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: locationCtrl,
                      decoration: const InputDecoration(
                        hintText: 'City, street, area',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Price Range',
                      style: AppTextStyle.inputBox.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<PriceFilter>(
                      initialValue: selectedPrice,
                      style: AppTextStyle.inputBox.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.sell_outlined),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: PriceFilter.any,
                          child: Text(
                            'Any',
                            style: AppTextStyle.inputBox.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: PriceFilter.budget,
                          child: Text(
                            'Budget',
                            style: AppTextStyle.inputBox.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: PriceFilter.mid,
                          child: Text(
                            'Mid',
                            style: AppTextStyle.inputBox.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: PriceFilter.premium,
                          child: Text(
                            'Premium',
                            style: AppTextStyle.inputBox.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setSheetState(() => selectedPrice = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Minimum Rating',
                      style: AppTextStyle.inputBox.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    _RatingStarSelector(
                      selectedMinRating: selectedMinRating,
                      onChanged: (value) {
                        setSheetState(() => selectedMinRating = value);
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx, const _ShopFilters());
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                ctx,
                                _ShopFilters(
                                  categoryName: selectedCategory,
                                  locationQuery: locationCtrl.text.trim(),
                                  minRating: selectedMinRating.toDouble(),
                                  priceFilter: selectedPrice,
                                ),
                              );
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (applied == null) return;
    setState(() {
      _filters = applied;
    });
  }

  bool _matchesCategoryAndLocation(ShopEntity shop) {
    final category = (_filters.categoryName ?? '').trim().toLowerCase();
    final location = _filters.locationQuery.trim().toLowerCase();
    final description = (shop.description ?? '').toLowerCase();
    final haystack = '${shop.shopName} ${shop.shopAddress} $description'
        .toLowerCase();
    final categoryFromField = shop.categoryNames
        .map((e) => e.toLowerCase())
        .toList();

    final matchesCategory =
        category.isEmpty ||
        categoryFromField.any((name) => name.contains(category)) ||
        haystack.contains(category);
    final matchesLocation =
        location.isEmpty || shop.shopAddress.toLowerCase().contains(location);
    return matchesCategory && matchesLocation;
  }

  bool _matchesPrice(ShopEntity shop) {
    if (_filters.priceFilter == PriceFilter.any) return true;
    final price = (shop.priceRange ?? '').trim().toLowerCase();
    if (price.isNotEmpty) {
      switch (_filters.priceFilter) {
        case PriceFilter.budget:
          return price.contains('budget') ||
              price.contains('low') ||
              price.contains('cheap') ||
              price.contains('\$');
        case PriceFilter.mid:
          return price.contains('mid') ||
              price.contains('standard') ||
              price.contains('moderate') ||
              price.contains('\$\$');
        case PriceFilter.premium:
          return price.contains('premium') ||
              price.contains('high') ||
              price.contains('luxury') ||
              price.contains('\$\$\$');
        case PriceFilter.any:
          return true;
      }
    }

    final text =
        '${shop.shopName} ${shop.description ?? ''} ${shop.shopAddress}'
            .toLowerCase();
    final budgetKeywords = ['budget', 'cheap', 'affordable', 'low cost'];
    final premiumKeywords = ['premium', 'luxury', 'exclusive', 'high-end'];
    final midKeywords = ['mid', 'standard', 'moderate'];

    final isBudget = budgetKeywords.any(text.contains);
    final isPremium = premiumKeywords.any(text.contains);
    final isMid = midKeywords.any(text.contains);

    switch (_filters.priceFilter) {
      case PriceFilter.budget:
        return isBudget;
      case PriceFilter.mid:
        return isMid || (!isBudget && !isPremium);
      case PriceFilter.premium:
        return isPremium;
      case PriceFilter.any:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SensorState>(sensorViewModelProvider, (previous, next) {
      final previousCount = previous?.shakeCount ?? 0;
      if (next.shakeCount > previousCount) {
        _onShakeDetected();
      }
    });

    final shopState = ref.watch(shopViewModelProvider);
    final savedState = ref.watch(savedShopViewModelProvider);
    final favouriteState = ref.watch(favouriteViewModelProvider);
    final userReviewState = ref.watch(userReviewViewModelProvider);
    final reviewedIds = {
      ...userReviewState.reviewedShopIds,
      ...favouriteState.reviewedShopIds,
    };
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = shopState.publicShops.where((shop) {
      final queryMatch =
          query.isEmpty ||
          shop.shopName.toLowerCase().contains(query) ||
          shop.shopAddress.toLowerCase().contains(query) ||
          shop.shopContact.toLowerCase().contains(query);
      return queryMatch &&
          _matchesCategoryAndLocation(shop) &&
          _matchesPrice(shop);
    }).toList();

    final isLoadingInitial =
        shopState.isLoadingPublic && !shopState.hasLoadedPublic;

    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: _refreshFeeds,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: _TopBanner(
                  searchCtrl: _searchCtrl,
                  activeFilterCount: _filters.activeCount,
                  loadingCategories: _isLoadingCategories,
                  onQueryChanged: () {
                    setState(() {});
                  },
                  onClear: () {
                    setState(() {
                      _searchCtrl.clear();
                    });
                  },
                  onOpenFilters: _openFilters,
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
                    final previewAsync = ref.watch(
                      shopCardPreviewProvider(shop),
                    );
                    final ratingPass = _filters.minRating <= 0
                        ? true
                        : previewAsync.maybeWhen(
                            data: (value) =>
                                value.averageRating >= _filters.minRating,
                            orElse: () => true,
                          );
                    if (!ratingPass) {
                      return const SizedBox.shrink();
                    }
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
                        isReviewed: reviewedIds.contains(shop.shopId ?? ''),
                        isSaveBusy: savedState.processingShopIds.contains(
                          shop.shopId ?? '',
                        ),
                        isFavouriteBusy: favouriteState.processingShopIds
                            .contains(shop.shopId ?? ''),
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
    required this.onOpenFilters,
    required this.activeFilterCount,
    required this.loadingCategories,
    required this.onQueryChanged,
    required this.onClear,
  });
  final TextEditingController searchCtrl;
  final VoidCallback onOpenFilters;
  final int activeFilterCount;
  final bool loadingCategories;
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
              suffixIcon: SizedBox(
                width: 86,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (searchCtrl.text.isNotEmpty)
                      IconButton(
                        onPressed: onClear,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    IconButton(
                      onPressed: loadingCategories ? null : onOpenFilters,
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.tune_rounded, color: Colors.white),
                          if (activeFilterCount > 0)
                            Positioned(
                              right: -4,
                              top: -5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$activeFilterCount',
                                  style: AppTextStyle.inputBox.copyWith(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
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

enum PriceFilter { any, budget, mid, premium }

class _RatingStarSelector extends StatelessWidget {
  const _RatingStarSelector({
    required this.selectedMinRating,
    required this.onChanged,
  });

  final int selectedMinRating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _RatingChip(
          label: 'Any',
          active: selectedMinRating == 0,
          onTap: () => onChanged(0),
        ),
        ...List.generate(5, (index) {
          final rating = index + 1;
          return _RatingChip(
            label: '$rating+',
            active: selectedMinRating == rating,
            onTap: () => onChanged(rating),
            showStar: true,
          );
        }),
      ],
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({
    required this.label,
    required this.active,
    required this.onTap,
    this.showStar = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.warning.withValues(alpha: 0.16)
              : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.warning : AppColors.accent2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showStar) ...[
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.warning,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: AppTextStyle.inputBox.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopFilters {
  final String? categoryName;
  final String locationQuery;
  final double minRating;
  final PriceFilter priceFilter;

  const _ShopFilters({
    this.categoryName,
    this.locationQuery = '',
    this.minRating = 0,
    this.priceFilter = PriceFilter.any,
  });

  int get activeCount {
    var count = 0;
    if ((categoryName ?? '').trim().isNotEmpty) count++;
    if (locationQuery.trim().isNotEmpty) count++;
    if (minRating > 0) count++;
    if (priceFilter != PriceFilter.any) count++;
    return count;
  }
}
