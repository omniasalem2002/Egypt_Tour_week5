class GuideModel {
  String uid;
  String city;
  String experience;
  int yearExperience;
  bool approved;
  double price;
  double rating;
  DateTime timestamp;

  GuideModel({
    required this.uid,
    required this.city,
    required this.experience,
    required this.yearExperience,
    required this.approved,
    required this.price,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'city': city,
      'experience': experience,
      'yearExperience': yearExperience,
      'approved': approved,
      'price': price,
      'rating': rating,
      'timestamp': timestamp,
    };
  }

  factory GuideModel.fromMap(Map<String, dynamic> map) {
    return GuideModel(
        uid: map['uid'] as String,
        city: map['city'] as String,
        experience: map['experience'] as String,
        yearExperience: map['yearExperience'].toInt(),
        approved: map['approved'] as bool,
        price: map['price'].toDouble(),
        rating: map['rating'].toDouble(),
        timestamp: map['timestamp'].toDate());
  }

  GuideModel copyWith({
    String? uid,
    String? city,
    String? experience,
    int? yearExperience,
    bool? approved,
    double? price,
    double? rating,
    DateTime? timestamp,
  }) {
    return GuideModel(
      uid: uid ?? this.uid,
      city: city ?? this.city,
      experience: experience ?? this.experience,
      yearExperience: yearExperience ?? this.yearExperience,
      approved: approved ?? this.approved,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
