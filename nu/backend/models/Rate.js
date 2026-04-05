class Rate {
  constructor({
    ratingID,
    orderID,
    stars,
    comment,
    reviewDateTime,
    providerReply,
    replyDateTime,
  }) {
    this.ratingID = ratingID;
    this.orderID = orderID;
    this.stars = stars;
    this.comment = comment;
    this.reviewDateTime = reviewDateTime;
    this.providerReply = providerReply;
    this.replyDateTime = replyDateTime;
  }

  static fromRow(row) {
    return new Rate({
      ratingID: row.ratingID,
      orderID: row.orderID,
      stars: row.stars,
      comment: row.comment,
      reviewDateTime: row.reviewDateTime,
      providerReply: row.providerReply,
      replyDateTime: row.replyDateTime,
    });
  }
}

module.exports = Rate;