class User {
  final String name;
  final String username;
  final String password;
  final profile_image;

  User(
      {required this.name,
      required this.username,
      required this.password,
      required this.profile_image});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "userName": username,
      "password": password,
      "profile_image": profile_image,
    };
  }
}
