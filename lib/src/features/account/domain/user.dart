class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? fcmToken;

  UserModel({this.id, this.email, this.name, this.fcmToken});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String?,
      email: map['email'] as String?,
      name: map['name'] as String?,
      fcmToken: map['fcmToken'] as String?,
    );
  }
}
