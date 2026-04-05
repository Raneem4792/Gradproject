class MealOrder {
  constructor({
    orderID,
    requestDate,
    status,
    pilgrimID,
    mealID,
    mealName,
  }) {
    this.orderID = orderID;
    this.requestDate = requestDate;
    this.status = status;
    this.pilgrimID = pilgrimID;
    this.mealID = mealID;
    this.mealName = mealName;
  }

  static fromRow(row) {
    return new MealOrder({
      orderID: row.orderID,
      requestDate: row.requestDate,
      status: row.status,
      pilgrimID: row.pilgrimID,
      mealID: row.mealID,
      mealName: row.mealName,
    });
  }
}

module.exports = MealOrder;