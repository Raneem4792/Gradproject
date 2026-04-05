class Rate {
  final int ratingID;
  final int orderID;
  final int stars;
  final String comment;
  final String reviewDateTime;
  final String providerReply;
  final String replyDateTime;

  Rate({
    required this.ratingID,
    required this.orderID,
    required this.stars,
    required this.comment,
    required this.reviewDateTime,
    required this.providerReply,
    required this.replyDateTime,
  });

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      ratingID: _toInt(json['ratingID']),
      orderID: _toInt(json['orderID']),
      stars: _toInt(json['stars']),
      comment: json['comment'] ?? '',
      reviewDateTime: json['reviewDateTime']?.toString() ?? '',
      providerReply: json['providerReply'] ?? '',
      replyDateTime: json['replyDateTime']?.toString() ?? '',
    );
  }
}