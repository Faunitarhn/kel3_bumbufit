import 'package:flutter/material.dart';
import 'package:translator/translator.dart'; // Import translator
import '../api/api_service.dart';
import '../models/nutrition.dart';
import '../widgets/nutrition_widget.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Map<String, dynamic>> _recipeDetail;
  Nutrition? _nutrition;
  final GoogleTranslator _translator =
      GoogleTranslator(); // Buat instance translator

  @override
  void initState() {
    super.initState();
    _recipeDetail = ApiService().getRecipeDetail(widget.recipeId);
  }

  Future<void> _loadNutrition() async {
    try {
      final nutritionData =
          await ApiService().getNutritionById(widget.recipeId);
      setState(() {
        _nutrition = Nutrition.fromJson(nutritionData);
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // Fungsi untuk menerjemahkan teks ke Bahasa Indonesia
  Future<String> _translateToIndonesian(String text) async {
    final translation = await _translator.translate(text, to: 'id');
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'Detail Resep',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final recipe = snapshot.data!;
            final recipeTitle = recipe['title'];
            final recipeImageUrl = recipe['image'];
            final recipeInstructions = recipe['instructions'];
            final ingredients = recipe['extendedIngredients'];
            final readyInMinutes = recipe['readyInMinutes'];
            final servings = recipe['servings'];
            final dishTypes = recipe['dishTypes'] as List<dynamic>;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Resep
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      recipeImageUrl,
                      height: 250.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Informasi dasar resep
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Resep
                        Text(
                          recipeTitle,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Waktu memasak dan porsi
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.green[700]),
                            const SizedBox(width: 8),
                            Text(
                              '$readyInMinutes menit',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.restaurant, color: Colors.green[700]),
                            const SizedBox(width: 8),
                            Text(
                              '$servings porsi',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Tipe masakan (kategori)
                        if (dishTypes.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: dishTypes.map((type) {
                              return Chip(
                                label: Text(type.toString()),
                                backgroundColor: Colors.green[50],
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),

                  // Daftar Bahan-bahan
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Bahan-Bahan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ingredients.map<Widget>((ingredient) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.check,
                                    color: Colors.green[700], size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: FutureBuilder<String>(
                                    future: _translateToIndonesian(
                                        ingredient['original']),
                                    builder: (context, translationSnapshot) {
                                      if (translationSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text('');
                                      } else if (translationSnapshot.hasError) {
                                        return Text(
                                            'Error: ${translationSnapshot.error}');
                                      } else {
                                        return Text(
                                          translationSnapshot.data ?? '',
                                          style: const TextStyle(fontSize: 16),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Instruksi memasak
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Instruksi Memasak',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<String>(
                        future: _translateToIndonesian(recipeInstructions),
                        builder: (context, translationSnapshot) {
                          if (translationSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (translationSnapshot.hasError) {
                            return Text('Error: ${translationSnapshot.error}');
                          } else {
                            return Text(
                              translationSnapshot.data ?? '',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // Tombol untuk informasi nutrisi
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _loadNutrition();
                        if (_nutrition != null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Nutrisi'),
                              content: NutritionWidget(
                                calories: _nutrition!.calories,
                                protein: _nutrition!.protein,
                                carbs: _nutrition!.carbs,
                                fat: _nutrition!.fat,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text(
                        'Tampilkan Nutrisi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
