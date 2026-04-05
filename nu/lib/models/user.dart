class User {
  final String userID;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;

  User({
    required this.userID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? {};

    return User(
      userID: userData['pilgrimID'] ?? userData['providerID'] ?? '',
      fullName: userData['fullName'] ?? '',
      email: userData['email'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      role: json['role'] ?? '',
    );
  }
}