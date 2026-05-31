class Rate {
  constructor({
    ratingID,
    orderID,
    stars,
    comment,
    reviewDateTime,
  }) {
    this.ratingID = ratingID;
    this.orderID = orderID;
    this.stars = stars;
    this.comment = comment;
    this.reviewDateTime = reviewDateTime;
  }

  static fromRow(row) {
    return new Rate({
      ratingID: row.ratingID,
      orderID: row.orderID,
      stars: row.stars,
      comment: row.comment,
      reviewDateTime: row.reviewDateTime,
    });
  }
}

module.exports = Rate;