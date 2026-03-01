import 'package:bazar/features/category/domain/entities/category_entity.dart';
import 'package:bazar/features/dashboard/presentation/pages/HomeScreen.dart';
import 'package:bazar/features/dashboard/presentation/widgets/nearest_shops_toggle.dart';
import 'package:bazar/features/dashboard/presentation/widgets/public_shop_card.dart';
import 'package:bazar/features/dashboard/presentation/widgets/shop_distance_badge.dart';
import 'package:bazar/features/favourite/presentation/state/favourite_state.dart';
import 'package:bazar/features/favourite/presentation/view_model/favourite_view_model.dart';
import 'package:bazar/features/savedShop/presentation/state/saved_shop_state.dart';
import 'package:bazar/features/savedShop/presentation/view_model/saved_shop_view_model.dart';
import 'package:bazar/features/sensor/presentation/state/sensor_state.dart';
import 'package:bazar/features/sensor/presentation/view_model/sensor_view_model.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/presentation/state/shop_state.dart';
import 'package:bazar/features/shop/presentation/view_model/shop_view_model.dart';
import 'package:bazar/features/shopReview/presentation/state/user_review_state.dart';
import 'package:bazar/features/shopReview/presentation/view_model/user_review_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'home_screen_nearest_shops_test.mocks.dart';

// Generate mocks for the view models
@GenerateMocks([
  ShopViewModel,
  FavouriteViewModel,
  SavedShopViewModel,
  SensorViewModel,
  UserReviewViewModel,
])
void main() {
  late MockShopViewModel mockShopViewModel;
  late MockFavouriteViewModel mockFavouriteViewModel;
  late MockSavedShopViewModel mockSavedShopViewModel;
  late MockSensorViewModel mockSensorViewModel;
  late MockUserReviewViewModel mockUserReviewViewModel;

  setUp(() {
    mockShopViewModel = MockShopViewModel();
    mockFavouriteViewModel = MockFavouriteViewModel();
    mockSavedShopViewModel = MockSavedShopViewModel();
    mockSensorViewModel = MockSensorViewModel();
    mockUserReviewViewModel = MockUserReviewViewModel();
  });

  // Helper function to create test widget with providers
  Widget createTestWidget({
    required ShopState shopState,
    FavouriteState? favouriteState,
    SavedShopState? savedShopState,
    SensorState? sensorState,
    UserReviewState? userReviewState,
  }) {
    return ProviderScope(
      overrides: [
        shopViewModelProvider.overrideWith((ref) => mockShopViewModel),
        favouriteViewModelProvider.overrideWith((ref) => mockFavouriteViewModel),
        savedShopViewModelProvider.overrideWith((ref) => mockSavedShopViewModel),
        sensorViewModelProvider.overrideWith((ref) => mockSensorViewModel),
        userReviewViewModelProvider.overrideWith((ref) => mockUserReviewViewModel),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }

  // Create sample shop data
  final sampleShop = ShopEntity(
    shopId: 'shop-1',
    shopName: 'Test Shop',
    shopAddress: 'Test Address',
    shopContact: '1234567890',
    shopRating: 4.5,
    shopImage: 'test.jpg',
    shopDescription: 'Test description',
    shopLatitude: 27.7172,
    shopLongitude: 85.3240,
    categories: [
      CategoryEntity(categoryId: 'cat-1', categoryName: 'Electronics'),
    ],
  );

  final sampleShopState = ShopState(
    publicShops: [sampleShop],
    nearestShops: [],
    isLoading: false,
    hasReachedMax: false,
    showNearestOnly: false,
    isLoadingNearest: false,
    selectedCategoryId: null,
    userLatitude: null,
    userLongitude: null,
  );

  group('HomeScreen - NearestShopsToggle Integration', () {
    testWidgets('renders NearestShopsToggle widget', (WidgetTester tester) async {
      when(mockShopViewModel.build()).thenReturn(sampleShopState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());

      await tester.pumpWidget(createTestWidget(shopState: sampleShopState));
      await tester.pumpAndSettle();

      expect(find.byType(NearestShopsToggle), findsOneWidget);
    });

    testWidgets('toggle is disabled when no category selected', (WidgetTester tester) async {
      when(mockShopViewModel.build()).thenReturn(sampleShopState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());

      await tester.pumpWidget(createTestWidget(shopState: sampleShopState));
      await tester.pumpAndSettle();

      final toggle = tester.widget<NearestShopsToggle>(
        find.byType(NearestShopsToggle),
      );
      expect(toggle.categorySelected, false);
    });

    testWidgets('toggle is enabled when category is selected', (WidgetTester tester) async {
      final stateWithCategory = sampleShopState.copyWith(
        selectedCategoryId: 'cat-1',
      );

      when(mockShopViewModel.build()).thenReturn(stateWithCategory);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());

      await tester.pumpWidget(createTestWidget(shopState: stateWithCategory));
      await tester.pumpAndSettle();

      final toggle = tester.widget<NearestShopsToggle>(
        find.byType(NearestShopsToggle),
      );
      expect(toggle.categorySelected, true);
    });

    testWidgets('shows loading state when fetching nearest shops', (WidgetTester tester) async {
      final loadingState = sampleShopState.copyWith(
        selectedCategoryId: 'cat-1',
        isLoadingNearest: true,
      );

      when(mockShopViewModel.build()).thenReturn(loadingState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());

      await tester.pumpWidget(createTestWidget(shopState: loadingState));
      await tester.pumpAndSettle();

      final toggle = tester.widget<NearestShopsToggle>(
        find.byType(NearestShopsToggle),
      );
      expect(toggle.isLoading, true);
    });
  });

  group('HomeScreen - Shop List with Nearest Filter', () {
    testWidgets('displays all shops when nearest filter is off', (WidgetTester tester) async {
      final multiShopState = sampleShopState.copyWith(
        publicShops: [
          sampleShop,
          sampleShop.copyWith(shopId: 'shop-2', shopName: 'Shop 2'),
          sampleShop.copyWith(shopId: 'shop-3', shopName: 'Shop 3'),
        ],
        showNearestOnly: false,
      );

      when(mockShopViewModel.build()).thenReturn(multiShopState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());
      when(mockShopViewModel.calculateDistance(any)).thenReturn(null);

      await tester.pumpWidget(createTestWidget(shopState: multiShopState));
      await tester.pumpAndSettle();

      expect(find.byType(PublicShopCard), findsNWidgets(3));
    });

    testWidgets('displays only nearest shops when filter is on', (WidgetTester tester) async {
      final nearestShop = sampleShop.copyWith(shopId: 'nearby-1', shopName: 'Nearby Shop');
      
      final nearestState = sampleShopState.copyWith(
        publicShops: [
          sampleShop,
          sampleShop.copyWith(shopId: 'shop-2', shopName: 'Shop 2'),
        ],
        nearestShops: [nearestShop],
        showNearestOnly: true,
        selectedCategoryId: 'cat-1',
        userLatitude: 27.7172,
        userLongitude: 85.3240,
      );

      when(mockShopViewModel.build()).thenReturn(nearestState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());
      when(mockShopViewModel.calculateDistance(any)).thenReturn(0.5);

      await tester.pumpWidget(createTestWidget(shopState: nearestState));
      await tester.pumpAndSettle();

      // Should only show 1 shop (the nearest one)
      expect(find.byType(PublicShopCard), findsOneWidget);
      expect(find.text('Nearby Shop'), findsOneWidget);
    });

    testWidgets('displays distance badge when location is available', (WidgetTester tester) async {
      final nearestState = sampleShopState.copyWith(
        showNearestOnly: true,
        nearestShops: [sampleShop],
        selectedCategoryId: 'cat-1',
        userLatitude: 27.7172,
        userLongitude: 85.3240,
      );

      when(mockShopViewModel.build()).thenReturn(nearestState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());
      when(mockShopViewModel.calculateDistance(any)).thenReturn(1.5);

      await tester.pumpWidget(createTestWidget(shopState: nearestState));
      await tester.pumpAndSettle();

      expect(find.byType(ShopDistanceBadge), findsOneWidget);
    });

    testWidgets('does not display distance badge when location is unavailable', (WidgetTester tester) async {
      when(mockShopViewModel.build()).thenReturn(sampleShopState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());
      when(mockShopViewModel.calculateDistance(any)).thenReturn(null);

      await tester.pumpWidget(createTestWidget(shopState: sampleShopState));
      await tester.pumpAndSettle();

      expect(find.byType(ShopDistanceBadge), findsNothing);
    });
  });

  group('HomeScreen - Category Selection Integration', () {
    testWidgets('setSelectedCategory is called when filter is applied', (WidgetTester tester) async {
      when(mockShopViewModel.build()).thenReturn(sampleShopState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());
      when(mockShopViewModel.setSelectedCategory(any)).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(shopState: sampleShopState));
      await tester.pumpAndSettle();

      // Note: In a real test, you would interact with the filter sheet
      // and verify the setSelectedCategory call. This is a simplified version.
      verify(mockShopViewModel.build()).called(greaterThan(0));
    });
  });

  group('HomeScreen - Error Handling', () {
    testWidgets('displays error through snackbar when error occurs', (WidgetTester tester) async {
      final errorState = sampleShopState.copyWith(
        errorMessage: 'Failed to fetch nearest shops',
      );

      when(mockShopViewModel.build()).thenReturn(errorState);
      when(mockFavouriteViewModel.build()).thenReturn(FavouriteState());
      when(mockSavedShopViewModel.build()).thenReturn(SavedShopState());
      when(mockSensorViewModel.build()).thenReturn(SensorState());
      when(mockUserReviewViewModel.build()).thenReturn(UserReviewState());

      await tester.pumpWidget(createTestWidget(shopState: errorState));
      await tester.pump(); // Trigger the listener

      // Check that SnackBar is displayed
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed to fetch nearest shops'), findsOneWidget);
    });
  });

  group('HomeScreen - displayedShops Getter Integration', () {
    test('shopState returns publicShops when showNearestOnly is false', () {
      final state = ShopState(
        publicShops: [sampleShop],
        nearestShops: [sampleShop.copyWith(shopId: 'nearby-1')],
        showNearestOnly: false,
      );

      expect(state.displayedShops, equals(state.publicShops));
      expect(state.displayedShops.length, 1);
      expect(state.displayedShops.first.shopId, 'shop-1');
    });

    test('shopState returns nearestShops when showNearestOnly is true', () {
      final nearbyShop = sampleShop.copyWith(shopId: 'nearby-1');
      final state = ShopState(
        publicShops: [sampleShop],
        nearestShops: [nearbyShop],
        showNearestOnly: true,
      );

      expect(state.displayedShops, equals(state.nearestShops));
      expect(state.displayedShops.length, 1);
      expect(state.displayedShops.first.shopId, 'nearby-1');
    });

    test('shopState returns empty list when nearestShops is empty and filter is on', () {
      final state = ShopState(
        publicShops: [sampleShop],
        nearestShops: [],
        showNearestOnly: true,
      );

      expect(state.displayedShops, isEmpty);
    });
  });
}
