import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/viewModel/restaurant_view_model.dart';

import '../../mock_function.dart';

void main() {
  // Data dummy yang akan digunakans
  final tRestaurant = Restaurant(
    id: '1',
    name: 'Test Restaurant',
    city: 'Test City',
    pictureId: '123',
    rating: 4.5,
    description: 'Desc',
  );
  final tRestaurantList = [tRestaurant];

  group("Restaurant View Model Unit Test (Provider)", () {
    late RestaurantViewModel viewModel;
    late MockRestaurantServices mockServices;

    setUp(() {
      mockServices = MockRestaurantServices();
      viewModel = RestaurantViewModel(mockServices);
    });

    test('Initial states should be in "Nothing" state', () {
      expect(viewModel.resultRestaurantList, isA<RestaurantListDataNothing>());
      expect(
        viewModel.resultRestaurantDetail,
        isA<RestaurantDetailDataNothing>(),
      );
      expect(
        viewModel.resultRestaurantSearch,
        isA<RestaurantSearchDataNothing>(),
      );
    });

    group('getListRestaurant', () {
      test('should change state to Loading then Loaded on success', () async {
        // Arrange
        mockServices.listResponseToReturn = RestaurantListResponse(
          error: false,
          message: 'Success',
          count: 1,
          restaurants: tRestaurantList,
        );

        viewModel.getListRestaurant();

        expect(
          viewModel.resultRestaurantList,
          isA<RestaurantListDataLoading>(),
        );

        // Tunggu proses async di dalam viewmodel selesai
        await Future.microtask(() {});

        // Setelah proses selesai maka state harus Loaded
        expect(viewModel.resultRestaurantList, isA<RestaurantListDataLoaded>());
        final result =
            viewModel.resultRestaurantList as RestaurantListDataLoaded;
        expect(result.data, tRestaurantList);
        expect(mockServices.getListRestaurantsCallCount, 1);
      });

      test('should change state to Loading then Error on failure', () async {
        mockServices.exceptionToThrow = Exception('Gagal Fetch');

        viewModel.getListRestaurant();

        // Cek state harus Loading jika memanggil viewModel pertamakali
        expect(
          viewModel.resultRestaurantList,
          isA<RestaurantListDataLoading>(),
        );

        // Tunggu proses async di dalam viewmodel selesai (agar state Loading berpindah ke loaded/error)
        await Future.microtask(() {});

        expect(viewModel.resultRestaurantList, isA<RestaurantListDataError>());
        expect(mockServices.getListRestaurantsCallCount, 1);
      });
    });

    group('getDetailRestaurant', () {
      const tId = '1';
      test('should change state to Loading then Loaded on success', () async {
        // Arrange
        mockServices.detailResponseToReturn = RestaurantDetailResponse(
          error: false,
          message: 'Success',
          restaurant: tRestaurant,
        );

        viewModel.getDetailRestaurant(tId);

        // Expect akan jadi loading
        expect(
          viewModel.resultRestaurantDetail,
          isA<RestaurantDetailDataLoading>(),
        );

        await Future.microtask(() {});

        expect(
          viewModel.resultRestaurantDetail,
          isA<RestaurantDetailDataLoaded>(),
        );
        final result =
            viewModel.resultRestaurantDetail as RestaurantDetailDataLoaded;
        expect(result.data, tRestaurant);
        expect(mockServices.getDetailRestaurantCallCount, 1);
      });
    });

    group('searchRestaurant', () {
      const tQuery = 'test';
      test('should change state to Loading then Loaded on success', () async {
        mockServices.searchResponseToReturn = RestaurantSearchResponse(
          error: false,
          founded: 1,
          restaurants: tRestaurantList,
        );

        viewModel.searchRestaurant(tQuery);

        expect(
          viewModel.resultRestaurantSearch,
          isA<RestaurantSearchDataLoading>(),
        );

        await Future.microtask(() {});

        expect(
          viewModel.resultRestaurantSearch,
          isA<RestaurantSearchDataLoaded>(),
        );
        final result =
            viewModel.resultRestaurantSearch as RestaurantSearchDataLoaded;
        expect(result.data, tRestaurantList);
        expect(mockServices.searchRestaurantsCallCount, 1);
      });
    });

    group('updateCustomerReviews', () {
      test('should update customer reviews in the detail state', () async {
        mockServices.detailResponseToReturn = RestaurantDetailResponse(
          error: false,
          message: 'Success',
          restaurant: tRestaurant,
        );
        viewModel.getDetailRestaurant('1');

        // tunggu proses getDetailRestaurant selesai agar state menjadi Loaded
        await Future.microtask(() {});

        // Cek state sudah Loaded sebelum melanjutkan
        expect(
          viewModel.resultRestaurantDetail,
          isA<RestaurantDetailDataLoaded>(),
        );

        // Siapkan data review baru
        final newReviews = [
          CustomerReview(name: 'Budi', review: 'Baru', date: '2025'),
        ];

        viewModel.updateCustomerReviews(newReviews);

        final result =
            viewModel.resultRestaurantDetail as RestaurantDetailDataLoaded;
        expect(result.data?.customerReviews, newReviews);
      });
    });
  });
}
