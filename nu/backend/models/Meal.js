class Meal {
  constructor({
    mealID,

    mealName,
    mealName_en,
    mealName_ar,

    mealType,
    mealType_en,
    mealType_ar,

    description,
    description_en,
    description_ar,

    protein,
    carbohydrates,
    fat,
    calories,
    image,
    providerID,
    providerName,
  }) {
    this.mealID = mealID;

    // الحقول القديمة نخليها موجودة عشان الفرونت القديم ما ينكسر
    this.mealName = mealName;
    this.mealType = mealType;
    this.description = description;

    // الحقول الجديدة
    this.mealName_en = mealName_en;
    this.mealName_ar = mealName_ar;
    this.mealType_en = mealType_en;
    this.mealType_ar = mealType_ar;
    this.description_en = description_en;
    this.description_ar = description_ar;

    this.protein = protein;
    this.carbohydrates = carbohydrates;
    this.fat = fat;
    this.calories = calories;
    this.image = image;
    this.providerID = providerID;
    this.providerName = providerName;
  }

  static fromRow(row) {
    return new Meal({
      mealID: row.mealID,

      mealName: row.mealName,
      mealName_en: row.mealName_en,
      mealName_ar: row.mealName_ar,

      mealType: row.mealType,
      mealType_en: row.mealType_en,
      mealType_ar: row.mealType_ar,

      description: row.description,
      description_en: row.description_en,
      description_ar: row.description_ar,

      protein: row.protein,
      carbohydrates: row.carbohydrates,
      fat: row.fat,
      calories: row.calories,
      image: row.image,
      providerID: row.providerID,
      providerName: row.providerName,
    });
  }
}

module.exports = Meal;