class MealOrder {
  constructor({
    orderID,
    requestDate,
    status,

    pilgrimID,
    pilgrimName,

    mealID,

    mealName,
    mealName_ar,
    mealName_en,

    mealType,
    mealType_ar,
    mealType_en,

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

    // القديم نخليه عشان الفرونت القديم ما ينكسر
    this.mealName = mealName;
    this.mealType = mealType;

    // الجديد
    this.mealName_ar = mealName_ar;
    this.mealName_en = mealName_en;

    this.mealType_ar = mealType_ar;
    this.mealType_en = mealType_en;

    this.campaignID = campaignID;
    this.campaignName = campaignName;
    this.campaignNumber = campaignNumber;

    this.stars = stars;
  }

  static fromRow(row) {
    const mealName =
      row.mealName ||
      row.mealName_en ||
      row.mealName_ar ||
      '';

    const mealNameAr =
      row.mealName_ar ||
      row.mealName ||
      row.mealName_en ||
      '';

    const mealNameEn =
      row.mealName_en ||
      row.mealName ||
      row.mealName_ar ||
      '';

    const mealType =
      row.mealType ||
      row.mealType_en ||
      row.mealType_ar ||
      '';

    const mealTypeAr =
      row.mealType_ar ||
      row.mealType ||
      row.mealType_en ||
      '';

    const mealTypeEn =
      row.mealType_en ||
      row.mealType ||
      row.mealType_ar ||
      '';

    return new MealOrder({
      orderID: row.orderID,
      requestDate: row.requestDate,
      status: row.status,

      pilgrimID: row.pilgrimID,
      pilgrimName: row.pilgrimName,

      mealID: row.mealID,

      mealName,
      mealName_ar: mealNameAr,
      mealName_en: mealNameEn,

      mealType,
      mealType_ar: mealTypeAr,
      mealType_en: mealTypeEn,

      campaignID: row.campaignID,
      campaignName: row.campaignName,
      campaignNumber: row.campaignNumber,

      stars: row.stars,
    });
  }
}

module.exports = MealOrder;