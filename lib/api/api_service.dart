import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = '67af5d9372674a8da482aa29e660a25e';

  // URL builder for recipe images
  static String buildRecipeImageUrl(int id, String imageType,
      {String size = '312x231'}) {
    return 'https://img.spoonacular.com/recipes/$id-$size.$imageType';
  }

  // URL builder for ingredient images
  static String buildIngredientImageUrl(String imageName,
      {String size = '100x100'}) {
    return 'https://img.spoonacular.com/ingredients_$size/$imageName';
  }

  // URL builder for equipment images
  static String buildEquipmentImageUrl(String imageName,
      {String size = '100x100'}) {
    return 'https://img.spoonacular.com/equipment_$size/$imageName';
  }

  // Existing searchRecipesByIngredients method
  Future<List<dynamic>> searchRecipesByIngredients(String ingredients) async {
    final url = Uri.https('api.spoonacular.com', '/recipes/findByIngredients', {
      'ingredients': ingredients,
      'apiKey': apiKey,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Map<String, dynamic>> getRecipeDetail(int recipeId) async {
    final url =
        Uri.https('api.spoonacular.com', '/recipes/$recipeId/information', {
      'apiKey': apiKey,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }

  Future<Map<String, dynamic>> getNutritionById(int recipeId) async {
    final url = Uri.https(
        'api.spoonacular.com', '/recipes/$recipeId/nutritionWidget.json', {
      'apiKey': apiKey,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load nutrition data');
    }
  }
}
