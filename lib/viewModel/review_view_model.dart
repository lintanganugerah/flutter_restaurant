import 'package:flutter/widgets.dart';
import 'package:restaurant_flutter/model/customer_review.dart';
import 'package:restaurant_flutter/model/services/review_services.dart';
import 'package:restaurant_flutter/model/utils/error_message.dart';

class ReviewViewModel extends ChangeNotifier {
  ReviewServices _service;

  ReviewViewModel(this._service);

  //State or Result Review
  ResultReview _resultReview = ResultReviewNothing();

  ResultReview get resultReview => _resultReview;

  Future<void> postReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    _emit(ResultReviewLoading());
    try {
      final reviewData = CustomerReview(
        id: restaurantId,
        name: name,
        review: review,
      );
      final jsonPayload = reviewData.toJson();

      final response = await _service.postReviewRestaurant(jsonPayload);
      _emit(ResultReviewLoaded(response.customerReviews));
    } catch (e) {
      _emit(ResultReviewError(errorMessage(e)));
    }
  }

  void _emit(ResultReview state) {
    _resultReview = state;
    notifyListeners();
  }

  // Digunakan untuk memperbarui instance previousViewModel yang sudah ada
  // bukan membuat yang baru pada ProxyProvider
  void updateServices(ReviewServices newServices) {
    _service = newServices;
  }
}

sealed class ResultReview {}

//Nothing
class ResultReviewNothing extends ResultReview {}

//Loading
class ResultReviewLoading extends ResultReview {}

//Loaded
class ResultReviewLoaded extends ResultReview {
  final List<CustomerReview>? data;

  ResultReviewLoaded(this.data);
}

//Error
class ResultReviewError extends ResultReview {
  final String message;

  ResultReviewError(this.message);
}
