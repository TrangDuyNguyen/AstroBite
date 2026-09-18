class CommonFoodItem {
  const CommonFoodItem({
    required this.name,
    required this.baseWeightG,
    required this.baseCalories,
    required this.baseProteinG,
    required this.baseCarbsG,
    required this.baseFatG,
  });

  final String name;
  final int baseWeightG;
  final int baseCalories;
  final int baseProteinG;
  final int baseCarbsG;
  final int baseFatG;

  int calculateCalories(int weightG) {
    if (baseWeightG <= 0) return baseCalories;
    return (baseCalories * weightG / baseWeightG).round();
  }

  int calculateProtein(int weightG) {
    if (baseWeightG <= 0) return baseProteinG;
    return (baseProteinG * weightG / baseWeightG).round();
  }

  int calculateCarbs(int weightG) {
    if (baseWeightG <= 0) return baseCarbsG;
    return (baseCarbsG * weightG / baseWeightG).round();
  }

  int calculateFat(int weightG) {
    if (baseWeightG <= 0) return baseFatG;
    return (baseFatG * weightG / baseWeightG).round();
  }
}

/// Curated dataset of popular Vietnamese foods with standard nutritional values
const commonVietnameseFoods = <CommonFoodItem>[
  CommonFoodItem(
    name: 'Phở bò',
    baseWeightG: 350,
    baseCalories: 450,
    baseProteinG: 25,
    baseCarbsG: 55,
    baseFatG: 12,
  ),
  CommonFoodItem(
    name: 'Phở gà',
    baseWeightG: 350,
    baseCalories: 410,
    baseProteinG: 28,
    baseCarbsG: 52,
    baseFatG: 9,
  ),
  CommonFoodItem(
    name: 'Cơm tấm sườn',
    baseWeightG: 300,
    baseCalories: 550,
    baseProteinG: 30,
    baseCarbsG: 70,
    baseFatG: 16,
  ),
  CommonFoodItem(
    name: 'Cơm tấm sườn bì chả',
    baseWeightG: 380,
    baseCalories: 720,
    baseProteinG: 38,
    baseCarbsG: 80,
    baseFatG: 26,
  ),
  CommonFoodItem(
    name: 'Bún chả Hà Nội',
    baseWeightG: 320,
    baseCalories: 480,
    baseProteinG: 22,
    baseCarbsG: 60,
    baseFatG: 15,
  ),
  CommonFoodItem(
    name: 'Bún bò Huế',
    baseWeightG: 400,
    baseCalories: 520,
    baseProteinG: 32,
    baseCarbsG: 58,
    baseFatG: 17,
  ),
  CommonFoodItem(
    name: 'Bánh mì thịt patê',
    baseWeightG: 180,
    baseCalories: 380,
    baseProteinG: 18,
    baseCarbsG: 45,
    baseFatG: 14,
  ),
  CommonFoodItem(
    name: 'Bánh mì ốp la (2 trứng)',
    baseWeightG: 180,
    baseCalories: 360,
    baseProteinG: 16,
    baseCarbsG: 42,
    baseFatG: 13,
  ),
  CommonFoodItem(
    name: 'Gỏi cuốn tôm thịt (2 cuốn)',
    baseWeightG: 150,
    baseCalories: 180,
    baseProteinG: 10,
    baseCarbsG: 28,
    baseFatG: 3,
  ),
  CommonFoodItem(
    name: 'Ức gà áp chảo',
    baseWeightG: 100,
    baseCalories: 165,
    baseProteinG: 31,
    baseCarbsG: 0,
    baseFatG: 4,
  ),
  CommonFoodItem(
    name: 'Cơm trắng (1 chén)',
    baseWeightG: 150,
    baseCalories: 200,
    baseProteinG: 4,
    baseCarbsG: 44,
    baseFatG: 0,
  ),
  CommonFoodItem(
    name: 'Trứng gà luộc (1 quả)',
    baseWeightG: 50,
    baseCalories: 78,
    baseProteinG: 6,
    baseCarbsG: 1,
    baseFatG: 5,
  ),
  CommonFoodItem(
    name: 'Canh chua cá lóc',
    baseWeightG: 250,
    baseCalories: 150,
    baseProteinG: 18,
    baseCarbsG: 10,
    baseFatG: 4,
  ),
  CommonFoodItem(
    name: 'Rau muống xào tỏi',
    baseWeightG: 150,
    baseCalories: 110,
    baseProteinG: 4,
    baseCarbsG: 8,
    baseFatG: 7,
  ),
  CommonFoodItem(
    name: 'Khoai lang luộc',
    baseWeightG: 150,
    baseCalories: 130,
    baseProteinG: 2,
    baseCarbsG: 30,
    baseFatG: 0,
  ),
  CommonFoodItem(
    name: 'Chuối già (1 quả)',
    baseWeightG: 120,
    baseCalories: 105,
    baseProteinG: 1,
    baseCarbsG: 27,
    baseFatG: 0,
  ),
  CommonFoodItem(
    name: 'Sữa tươi không đường',
    baseWeightG: 200,
    baseCalories: 124,
    baseProteinG: 6,
    baseCarbsG: 10,
    baseFatG: 7,
  ),
];
