class MealOrder {
  constructor({
    orderID,
    requestDate,
    status,
    pilgrimID,
    pilgrimName,
    mealID,
    mealName,
    mealType,
    campaignID,
    campaignName,
    campaignNumber,
    stars,
  }) {
    this.orderID = orderID;
    this.requestDate = requestDate;
    this.status = status;
    this.pilgrimID = pilgrimID;
    this.pilgrimName = pilgrimName;
    this.mealID = mealID;
    this.mealName = mealName;
    this.mealType = mealType;
    this.campaignID = campaignID;
    this.campaignName = campaignName;
    this.campaignNumber = campaignNumber;
    this.stars = stars;
  }

  static fromRow(row) {
    return new MealOrder({
      orderID: row.orderID,
      requestDate: row.requestDate,
      status: row.status,
      pilgrimID: row.pilgrimID,
      pilgrimName: row.pilgrimName,
      mealID: row.mealID,
      mealName: row.mealName,
      mealType: row.mealType,
      campaignID: row.campaignID,
      campaignName: row.campaignName,
      campaignNumber: row.campaignNumber,
      stars: row.stars,
    });
  }
}

module.exports = MealOrder;