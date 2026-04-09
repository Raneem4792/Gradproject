class Campaign {
  final int campaignID;
  final String campaignName;
  final String campaignNumber;
  final int numberOfPilgrims;
  final String arrivalDetails;
  final String providerID;

  Campaign({
    required this.campaignID,
    required this.campaignName,
    required this.campaignNumber,
    required this.numberOfPilgrims,
    required this.arrivalDetails,
    required this.providerID,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      campaignID: json['campaignID'],
      campaignName: json['campaignName'] ?? '',
      campaignNumber: json['campaignNumber'] ?? '',
      numberOfPilgrims: json['numberOfPilgrims'] ?? 0,
      arrivalDetails: json['arrivalDetails'] ?? '',
      providerID: json['providerID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'campaignID': campaignID,
      'campaignName': campaignName,
      'campaignNumber': campaignNumber,
      'numberOfPilgrims': numberOfPilgrims,
      'arrivalDetails': arrivalDetails,
      'providerID': providerID,
    };
  }
}