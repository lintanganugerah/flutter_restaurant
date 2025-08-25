class CustomerReview {
  String name;
  String review;
  String? date;
  String? id;

  CustomerReview({
    required this.name,
    required this.review,
    this.date,
    this.id,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) => CustomerReview(
    name: json["name"],
    review: json["review"],
    date: json["date"],
  );

  Map<String, Object> toJson() => {
    "id": id ?? '',
    "name": name,
    "review": review,
  };
}

class AddReviewResponse {
  bool error;
  String message;
  List<CustomerReview> customerReviews;

  AddReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory AddReviewResponse.fromJson(Map<String, dynamic> json) =>
      AddReviewResponse(
        error: json["error"],
        message: json["message"],
        customerReviews: List<CustomerReview>.from(
          json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
        ),
      );
}
