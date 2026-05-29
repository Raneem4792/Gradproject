class AdminProviderAccount {
  final String providerID;
  final String providerName;
  final String providerEmail;
  final String? providerPhone;
  final String providerStatus;

  final List<AdminCampaign> campaigns;

  AdminProviderAccount({
    required this.providerID,
    required this.providerName,
    required this.providerEmail,
    this.providerPhone,
    required this.providerStatus,
    required this.campaigns,
  });

  factory AdminProviderAccount.fromJson(Map<String, dynamic> json) {
    return AdminProviderAccount(
      providerID: json['providerID']?.toString() ?? '',
      providerName: json['providerName']?.toString() ?? '',
      providerEmail: json['providerEmail']?.toString() ?? '',
      providerPhone: json['providerPhone']?.toString(),
      providerStatus: json['providerStatus']?.toString() ?? 'active',
      campaigns: (json['campaigns'] as List<dynamic>? ?? [])
          .map((item) => AdminCampaign.fromJson(item))
          .toList(),
    );
  }
}

class AdminCampaign {
  final int campaignID;
  final String campaignName;
  final String? campaignNumber;
  final int numberOfPilgrims;
  final String? arrivalDetails;
  final List<AdminPilgrim> pilgrims;

  AdminCampaign({
    required this.campaignID,
    required this.campaignName,
    this.campaignNumber,
    required this.numberOfPilgrims,
    this.arrivalDetails,
    required this.pilgrims,
  });

  factory AdminCampaign.fromJson(Map<String, dynamic> json) {
    return AdminCampaign(
      campaignID: int.tryParse(json['campaignID']?.toString() ?? '') ?? 0,
      campaignName: json['campaignName']?.toString() ?? '',
      campaignNumber: json['campaignNumber']?.toString(),
      numberOfPilgrims:
          int.tryParse(json['numberOfPilgrims']?.toString() ?? '') ?? 0,
      arrivalDetails: json['arrivalDetails']?.toString(),
      pilgrims: (json['pilgrims'] as List<dynamic>? ?? [])
          .map((item) => AdminPilgrim.fromJson(item))
          .toList(),
    );
  }
}

class AdminPilgrim {
  final String pilgrimID;
  final String pilgrimName;
  final String pilgrimEmail;
  final String? pilgrimPhone;
  final String pilgrimStatus;

  AdminPilgrim({
    required this.pilgrimID,
    required this.pilgrimName,
    required this.pilgrimEmail,
    this.pilgrimPhone,
    required this.pilgrimStatus,
  });

  factory AdminPilgrim.fromJson(Map<String, dynamic> json) {
    return AdminPilgrim(
      pilgrimID: json['pilgrimID']?.toString() ?? '',
      pilgrimName: json['pilgrimName']?.toString() ?? '',
      pilgrimEmail: json['pilgrimEmail']?.toString() ?? '',
      pilgrimPhone: json['pilgrimPhone']?.toString(),
      pilgrimStatus: json['pilgrimStatus']?.toString() ?? 'active',
    );
  }
}