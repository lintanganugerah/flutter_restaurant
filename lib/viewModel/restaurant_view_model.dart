import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/model/restaurant.dart';
import 'package:restaurant_flutter/model/services/restaurant_services.dart';

class RestaurantViewModel extends ChangeNotifier {
  final RestaurantServices client;

  RestaurantViewModel(this.client);

  //State or Result Restaurant List
  RestaurantListData _resultRestaurantList = RestaurantListDataNothing();

  RestaurantListData get resultRestaurantList => _resultRestaurantList;

  //State or Result Restaurant Detail
  RestaurantDetailData _resultRestaurantDetail = RestaurantDetailDataNothing();

  RestaurantDetailData get resultRestaurantDetail => _resultRestaurantDetail;

  void getListRestaurant() async {
    _emitList(RestaurantListDataLoading());
    try {
      final data = await client.getListRestaurants();
      _emitList(RestaurantListDataLoaded(data.restaurants));
    } catch (e) {
      _emitList(RestaurantListDataError(e.toString()));
    }
  }

  void getDetailRestaurant(String id) async {
    _emitDetail(RestaurantDetailDataLoading());
    try {
      final data = await client.getDetailRestaurant(id);
      _emitDetail(RestaurantDetailDataLoaded(data.restaurant));
    } catch (e) {
      _emitDetail(RestaurantDetailDataError(e.toString()));
    }
  }

  void _emitList(RestaurantListData state) {
    _resultRestaurantList = state;
    notifyListeners();
  }

  void _emitDetail(RestaurantDetailData state) {
    _resultRestaurantDetail = state;
    notifyListeners();
  }

  void cleanDetailRestaurantData() {
    _emitDetail(RestaurantDetailDataNothing());
  }
}

sealed class RestaurantListData {}

sealed class RestaurantDetailData {}

//Nothing
class RestaurantListDataNothing extends RestaurantListData {}

class RestaurantDetailDataNothing extends RestaurantDetailData {}

//Loading
class RestaurantListDataLoading extends RestaurantListData {}

class RestaurantDetailDataLoading extends RestaurantDetailData {}

//Loaded
class RestaurantListDataLoaded extends RestaurantListData {
  final List<Restaurant>? data;

  RestaurantListDataLoaded(this.data);
}

class RestaurantDetailDataLoaded extends RestaurantDetailData {
  final Restaurant? data;

  RestaurantDetailDataLoaded(this.data);
}

//Error
class RestaurantListDataError extends RestaurantListData {
  final String message;

  RestaurantListDataError(this.message);
}

class RestaurantDetailDataError extends RestaurantDetailData {
  final String message;

  RestaurantDetailDataError(this.message);
}
