class GuideDetails{
  String uid;
  String name;
  String mail;
  String phoneNumber;
  String image;
  String city;
  double rating;
  String experience;
  double price;
  bool approved;
  String token;

  GuideDetails({
    required this.uid,
    required this.name,
    required this.mail,
    required this.phoneNumber,
    required this.image,
    required this.city,
    required this.rating,
    required this.experience,
    required this.price,
    required this.approved,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mail': mail,
      'phoneNumber': phoneNumber,
      'image': image,
      'city': city,
      'rating': rating,
      'experience': experience,
      'price': price,
      'approved': approved,
      'token': token,
    };
  }

  factory GuideDetails.fromMap(Map<String, dynamic> map) {
    return GuideDetails(
      uid: map['uid'] as String,
      name: map['name'] as String,
      mail: map['mail'] as String,
      phoneNumber: map['phoneNumber'] as String,
      image: map['image'] as String,
      city: map['city'] as String,
      rating: map['rating'] as double,
      experience: map['experience'] as String,
      price: map['price'].toDouble(),
      approved: map['approved'] as bool,
        token: map['token'] as String,
    );
  }

  GuideDetails copyWith({
    String? uid,
    String? name,
    String? mail,
    String? phoneNumber,
    String? image,
    String? city,
    double? rating,
    String? experience,
    double? price,
    bool? approved,
    String? token,
  }) {
    return GuideDetails(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      mail: mail ?? this.mail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      experience: experience ?? this.experience,
      price: price ?? this.price,
      approved: approved ?? this.approved,
        token: token ?? this.token,
    );
  }
}