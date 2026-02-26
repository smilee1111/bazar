import 'package:bazar/app/theme/colors.dart';
import 'package:bazar/app/theme/textstyle.dart';
import 'package:flutter/material.dart';

class HomeTopBanner extends StatelessWidget {
  const HomeTopBanner({
    super.key,
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.darkBrown],
        ),
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
              prefixIcon:
                  const Icon(Icons.search_rounded, color: Colors.white),
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
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.white, width: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
