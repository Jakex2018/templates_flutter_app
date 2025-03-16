class UserModel {
  String? email;
  String? username;
  bool? isSubscribed;
  String id;
  UserModel(
      {this.email = '',
      this.username = "",
      this.isSubscribed = false,
      required this.id});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      isSubscribed: map['isSubscribed'] ?? false,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      isSubscribed: json['isSubscribed'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'username': username, 'isSubscribed': isSubscribed};
  }
}