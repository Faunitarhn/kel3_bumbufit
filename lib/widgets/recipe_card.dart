import 'package:bumbufitapp/screens/recipe_detail_screen.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';

class RecipeCard extends StatelessWidget {
  final int id;
  final String title;
  final String imageType;

  const RecipeCard({
    required this.id,
    required this.title,
    required this.imageType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          ApiService.buildRecipeImageUrl(id, imageType),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported);
          },
        ),
        title: Text(title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipeId: id),
            ),
          );
        },
      ),
    );
  }
}
