import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ingredientsController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;

  Future<void> _searchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final recipes = await ApiService().searchRecipesByIngredients(
        _ingredientsController.text,
      );
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'BumbuFit',
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
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              // Tambahkan aksi di sini
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Cari dengan bahan yang anda punya',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
            ),
            const SizedBox(height: 20),

            // TextField for ingredients input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Masukan bahan (Dipisah dengan koma)',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search Button
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _searchRecipes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Cari',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Recipe List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recipes.isEmpty
                      ? const Center(child: Text('Tidak ditemukan.'))
                      : ListView.builder(
                          itemCount: _recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = _recipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: RecipeCard(
                                id: recipe['id'],
                                title: recipe['title'],
                                imageType: recipe['imageType'],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
