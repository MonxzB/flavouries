import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/CardFearture/recipe_card2.dart';

class ListCard2 extends StatefulWidget {
  const ListCard2({Key? key}) : super(key: key);

  @override
  State<ListCard2> createState() => _ListCard2State();
}

class _ListCard2State extends State<ListCard2> {
  List<Map<String, dynamic>> recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('recipes').get();

      final fetched =
          querySnapshot.docs.map((doc) {
            final data = doc.data();

            final ingredients =
                (data['ingredients'] as List)
                    .map((e) => Map<String, String>.from(e))
                    .toList();

            final steps =
                (data['steps'] as List)
                    .map((e) => Map<String, dynamic>.from(e))
                    .toList();

            return {
              'id': doc.id,
              'imageUrl': data['image_url'] ?? '',
              'title': data['title'] ?? '',
              'description': data['description'] ?? '',
              'ingredients': ingredients,
              'steps': steps,
              'kcal': data['calories']?.toString() ?? '0',
              'time': '${steps.length} mins',
              'chefImage': 'https://i.pravatar.cc/100?u=${data['chef_id']}',
              'chefName': 'Chef ${data['chef_id'] ?? 'Unknown'}',
              'isLiked': false,
              'likes': 0,
            };
          }).toList();

      setState(() {
        recipes = fetched;
      });
    } catch (e) {
      print("❌ Error loading recipes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child:
          recipes.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                reverse: true, // Hiển thị từ dưới lên
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RecipeCard2(
                      recipeId: recipe["id"],
                      imageUrl: recipe["imageUrl"],
                      title: recipe["title"],
                      description: recipe["description"],
                      ingredients: List<Map<String, String>>.from(
                        recipe["ingredients"],
                      ),
                      steps: List<Map<String, dynamic>>.from(recipe["steps"]),
                      kcal: recipe["kcal"],
                      time: recipe["time"],
                      chefName: recipe["chefName"],
                      chefImage: recipe["chefImage"],
                      likes: recipe["likes"],
                      isLiked: recipe["isLiked"],
                    ),
                  );
                },
              ),
    );
  }
}
