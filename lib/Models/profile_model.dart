class ProfileModel {
  String uid;
  String name;
  String mail;
  String image;
  String phoneNumber;
  String whatsappNumber;
  String token;
  String role;
  DateTime timestamp;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.mail,
    required this.image,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.token,
    required this.role,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'mail': mail,
      'image': image,
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
      'token': token,
      'role': role,
      'timestamp': timestamp,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      mail: map['mail'] as String,
      image: map['image'] as String,
      phoneNumber: map['phoneNumber'] as String,
      whatsappNumber: map['whatsappNumber'] as String,
      token: map['token'] as String,
      role: map['role'] as String,
      timestamp: map['timestamp'].toDate() as DateTime,
    );
  }

  ProfileModel copyWith({
    String? uid,
    String? name,
    String? mail,
    String? image,
    String? phoneNumber,
    String? whatsappNumber,
    String? token,
    String? role,
    DateTime? timestamp,
  }) {
    return ProfileModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      mail: mail ?? this.mail,
      image: image ?? this.image,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      token: token ?? this.token,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
