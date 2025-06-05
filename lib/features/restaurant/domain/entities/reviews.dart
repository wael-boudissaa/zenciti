
class ReviewProfile {
    final String firstName;
    final String lastName;
    final int rating;
    final  String comment;
    final DateTime createdAt;


  ReviewProfile({
    required this.firstName,
    required this.lastName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
  factory ReviewProfile.fromJson(Map<String, dynamic> json) {
    return ReviewProfile(
        firstName: json['firstName'],
        lastName: json['lastName'],
        rating: json['rating'],
        comment: json['comment'],
        createdAt: DateTime.parse(json['createdAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
        'firstName': firstName,
        'lastName': lastName,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
    };

  }
}
