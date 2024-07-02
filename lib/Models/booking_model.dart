class BookingModel {
  String id;
  String user;
  String guide;
  String city;
  String status;
  DateTime tripDate;
  DateTime timestamp;

  BookingModel({
    required this.id,
    required this.user,
    required this.guide,
    required this.city,
    required this.status,
    required this.tripDate,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
      'guide': guide,
      'city': city,
      'status': status,
      'tripDate': tripDate,
      'timestamp': timestamp,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as String,
      user: map['user'] as String,
      guide: map['guide'] as String,
      city: map['city'] as String,
        status: map['status'] as String,
      tripDate: map['tripDate'].toDate() as DateTime,
      timestamp: map['timestamp'].toDate() as DateTime,
    );
  }

  BookingModel copyWith({
    String? id,
    String? user,
    String? guide,
    String? city,
    String? status,
    DateTime? tripDate,
    DateTime? timestamp,
  }) {
    return BookingModel(
      id: id ?? this.id,
      user: user ?? this.user,
      guide: guide ?? this.guide,
      city: city ?? this.city,
      status: status ?? this.status,
      tripDate: tripDate ?? this.tripDate,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}