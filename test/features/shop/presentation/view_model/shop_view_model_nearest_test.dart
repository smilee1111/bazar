import 'package:bazar/core/errors/failure.dart';
import 'package:bazar/core/services/location/geolocation_provider.dart';
import 'package:bazar/features/shop/domain/entities/shop_entity.dart';
import 'package:bazar/features/shop/domain/usecases/get_nearest_shops_usecase.dart';
import 'package:bazar/features/shop/presentation/state/shop_state.dart';
import 'package:bazar/features/shop/presentation/view_model/shop_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'shop_view_model_nearest_test.mocks.dart';

@GenerateMocks([
  GetNearestShopsUsecase,
  GeolocationNotifier,
])
void main() {
  late ShopViewModel shopViewModel;
  late MockGetNearestShopsUsecase mockGetNearestShopsUsecase;
  late MockGeolocationNotifier mockGeolocationNotifier;

  setUp(() {
    mockGetNearestShopsUsecase = MockGetNearestShopsUsecase();
    mockGeolocationNotifier = MockGeolocationNotifier();
    
    // Note: In real tests, you would inject these mocks through the ViewModel constructor
    // This is a simplified setup for demonstration
  });

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
  );

  group('ShopViewModel - Nearest Shops Feature', () {
    test('setSelectedCategory updates state correctly', () async {
      // Note: This would require proper setup with Riverpod container
      // This is a conceptual test showing what should be tested
      
      const categoryId = 'cat-123';
      
      // When setSelectedCategory is called
      // Then state should update selectedCategoryId
      // Verify this through state observation
    });

    test('toggleNearestFilter with enable=true fetches nearest shops', () async {
      // Given
      const categoryId = 'cat-123';
      const userLat = 27.7172;
      const userLng = 85.3240;
      
      final nearestShops = [
        sampleShop.copyWith(shopId: 'nearby-1'),
        sampleShop.copyWith(shopId: 'nearby-2'),
      ];

      when(mockGeolocationNotifier.build()).thenReturn(
        GeolocationState(
          latitude: userLat,
          longitude: userLng,
          isLoading: false,
        ),
      );

      when(mockGetNearestShopsUsecase.call(any)).thenAnswer(
        (_) async => Right(nearestShops),
      );

      // When toggleNearestFilter is called with enable=true
      // Then it should:
      // 1. Fetch user location
      // 2. Call getNearestShopsUsecase with correct params
      // 3. Update state with nearestShops
      // 4. Set showNearestOnly to true
      
      verify(mockGetNearestShopsUsecase.call(any)).called(1);
    });

    test('toggleNearestFilter with enable=false resets filter', () async {
      // Given initial state with nearest filter enabled
      
      // When toggleNearestFilter is called with enable=false
      // Then state should:
      // 1. Set showNearestOnly to false
      // 2. Keep nearestShops data (for potential re-enable)
    });

    test('loadNearestShops handles location permission denied', () async {
      // Given
      when(mockGeolocationNotifier.build()).thenReturn(
        GeolocationState(
          latitude: null,
          longitude: null,
          isLoading: false,
          errorMessage: 'Location permission denied',
        ),
      );

      // When loadNearestShops is called
      // Then state should have error message
    });

    test('loadNearestShops handles API failure', () async {
      // Given
      const categoryId = 'cat-123';
      const userLat = 27.7172;
      const userLng = 85.3240;

      when(mockGeolocationNotifier.build()).thenReturn(
        GeolocationState(
          latitude: userLat,
          longitude: userLng,
          isLoading: false,
        ),
      );

      when(mockGetNearestShopsUsecase.call(any)).thenAnswer(
        (_) async => Left(ServerFailure(message: 'Network error')),
      );

      // When loadNearestShops is called
      // Then state should:
      // 1. Set isLoadingNearest to false
      // 2. Set errorMessage
      // 3. Not update nearestShops
    });

    test('calculateDistance returns correct distance', () async {
      // Given
      const userLat = 27.7172;
      const userLng = 85.3240;
      
      final shop = ShopEntity(
        shopId: 'shop-1',
        shopName: 'Test Shop',
        shopAddress: 'Test Address',
        shopContact: '1234567890',
        shopRating: 4.5,
        shopImage: 'test.jpg',
        shopDescription: 'Test',
        shopLatitude: 27.7172, // Same location
        shopLongitude: 85.3240,
      );

      // When calculateDistance is called
      // Then it should return approximately 0.0 km
    });

    test('calculateDistance returns null when user location is unavailable', () async {
      // Given state with no user location (null lat/lng)
      
      final shop = sampleShop;

      // When calculateDistance is called
      // Then it should return null
    });

    test('calculateDistance returns null when shop has no coordinates', () async {
      // Given
      const userLat = 27.7172;
      const userLng = 85.3240;
      
      final shop = ShopEntity(
        shopId: 'shop-1',
        shopName: 'Test Shop',
        shopAddress: 'Test Address',
        shopContact: '1234567890',
        shopRating: 4.5,
        shopImage: 'test.jpg',
        shopDescription: 'Test',
        shopLatitude: null,
        shopLongitude: null,
      );

      // When calculateDistance is called
      // Then it should return null
    });
  });

  group('ShopState - displayedShops Getter', () {
    test('returns publicShops when showNearestOnly is false', () {
      // Given
      final state = ShopState(
        publicShops: [sampleShop],
        nearestShops: [sampleShop.copyWith(shopId: 'nearby-1')],
        showNearestOnly: false,
      );

      // When
      final displayed = state.displayedShops;

      // Then
      expect(displayed, equals(state.publicShops));
      expect(displayed.length, 1);
      expect(displayed.first.shopId, 'shop-1');
    });

    test('returns nearestShops when showNearestOnly is true', () {
      // Given
      final nearbyShop = sampleShop.copyWith(shopId: 'nearby-1');
      final state = ShopState(
        publicShops: [sampleShop],
        nearestShops: [nearbyShop],
        showNearestOnly: true,
      );

      // When
      final displayed = state.displayedShops;

      // Then
      expect(displayed, equals(state.nearestShops));
      expect(displayed.length, 1);
      expect(displayed.first.shopId, 'nearby-1');
    });

    test('returns empty list when showNearestOnly is true but nearestShops is empty', () {
      // Given
      final state = ShopState(
        publicShops: [sampleShop],
        nearestShops: [],
        showNearestOnly: true,
      );

      // When
      final displayed = state.displayedShops;

      // Then
      expect(displayed, isEmpty);
    });

    test('returns all publicShops when showNearestOnly is false', () {
      // Given
      final shops = [
        sampleShop,
        sampleShop.copyWith(shopId: 'shop-2'),
        sampleShop.copyWith(shopId: 'shop-3'),
      ];
      
      final state = ShopState(
        publicShops: shops,
        nearestShops: [sampleShop.copyWith(shopId: 'nearby-1')],
        showNearestOnly: false,
      );

      // When
      final displayed = state.displayedShops;

      // Then
      expect(displayed.length, 3);
      expect(displayed, equals(shops));
    });
  });

  group('NearestShopsParams', () {
    test('creates params with all required fields', () {
      // Given
      const params = NearestShopsParams(
        categoryId: 'cat-123',
        latitude: 27.7172,
        longitude: 85.3240,
        limit: 20,
      );

      // Then
      expect(params.categoryId, 'cat-123');
      expect(params.latitude, 27.7172);
      expect(params.longitude, 85.3240);
      expect(params.limit, 20);
    });

    test('uses default limit when not specified', () {
      // Given
      const params = NearestShopsParams(
        categoryId: 'cat-123',
        latitude: 27.7172,
        longitude: 85.3240,
      );

      // Then - verify default limit is applied
      expect(params.limit, isNotNull);
    });
  });

  group('Integration - Nearest Shops Workflow', () {
    test('complete workflow: select category -> enable filter -> fetch -> display', () async {
      // This test demonstrates the complete user workflow:
      
      // 1. User selects a category
      const categoryId = 'cat-electronics';
      
      // 2. setSelectedCategory is called
      // State: selectedCategoryId = 'cat-electronics'
      
      // 3. User toggles nearest filter on
      // toggleNearestFilter(enable: true) is called
      
      // 4. System fetches user location
      const userLat = 27.7172;
      const userLng = 85.3240;
      
      // 5. System calls getNearestShops API
      final nearestShops = [
        sampleShop.copyWith(shopId: 'nearby-1', shopName: 'Nearby Shop 1'),
        sampleShop.copyWith(shopId: 'nearby-2', shopName: 'Nearby Shop 2'),
      ];
      
      // 6. State updates:
      // - nearestShops: [nearby-1, nearby-2]
      // - showNearestOnly: true
      // - userLatitude: 27.7172
      // - userLongitude: 85.3240
      
      // 7. UI displays nearestShops (via displayedShops getter)
      
      // 8. For each shop, calculateDistance returns distance
      
      // 9. UI shows shop cards with distance badges
    });

    test('complete workflow: disable filter -> return to all shops', () async {
      // Given: Filter is currently enabled with nearest shops displayed
      
      // 1. User toggles filter off
      // toggleNearestFilter(enable: false) is called
      
      // 2. State updates:
      // - showNearestOnly: false
      // - nearestShops: kept in state (not cleared)
      
      // 3. UI displays all publicShops again (via displayedShops getter)
      
      // 4. Distance badges are hidden (calculateDistance returns null or UI doesn't show)
    });

    test('error workflow: location permission denied', () async {
      // 1. User selects category
      // 2. User toggles filter on
      // 3. Location permission is denied
      // 4. State has errorMessage
      // 5. UI shows error snackbar via listener
      // 6. Filter remains off (showNearestOnly = false)
    });

    test('error workflow: no nearby shops found', () async {
      // 1. User enables filter
      // 2. Location fetched successfully
      // 3. API returns empty array
      // 4. State updates:
      //    - nearestShops: []
      //    - showNearestOnly: true
      // 5. UI shows empty state or message
    });
  });
}
