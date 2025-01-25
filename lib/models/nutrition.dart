class Nutrition {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: int.parse(json['calories'].replaceAll('kcal', '').trim()),
      protein: double.parse(json['protein'].replaceAll('g', '').trim()),
      carbs: double.parse(json['carbs'].replaceAll('g', '').trim()),
      fat: double.parse(json['fat'].replaceAll('g', '').trim()),
    );
  }
}
