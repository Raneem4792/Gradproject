class ProviderProfile {
  final String providerID;
  final String fullName;
  final String email;
  final String phoneNumber;

  ProviderProfile({
    required this.providerID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      providerID: json['providerID'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'providerID': providerID,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}