class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final String summary;
  final List<dynamic> ingredients;
  final List<dynamic> instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
      summary: json['summary'],
      ingredients: json['extendedIngredients'],
      instructions: json['analyzedInstructions'],
    );
  }
}
