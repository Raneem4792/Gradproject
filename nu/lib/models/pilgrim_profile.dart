class PilgrimProfile {
  final String pilgrimID;
  final String fullName;
  final String email;
  final String phoneNumber;
  final int campaignID;
  final String campaignName;

  PilgrimProfile({
    required this.pilgrimID,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.campaignID,
    required this.campaignName,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  factory PilgrimProfile.fromJson(Map<String, dynamic> json) {
    return PilgrimProfile(
      pilgrimID: json['pilgrimID'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      campaignID: _toInt(json['campaignID']),
      campaignName: json['campaignName'] ?? '',
    );
  }
}