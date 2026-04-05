class Meal {
  constructor({
    mealID,
    mealName,
    mealType,
    description,
    protein,
    carbohydrates,
    fat,
    calories,
    image,
    providerID,
    providerName,
  }) {
    this.mealID = mealID;
    this.mealName = mealName;
    this.mealType = mealType;
    this.description = description;
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
      mealType: row.mealType,
      description: row.description,
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