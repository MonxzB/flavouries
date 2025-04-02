import 'package:flutter/material.dart';
import 'package:fluttertest/ui/CardMostSearch/recipe_card.dart';

class RecipeListSearch extends StatelessWidget {
  final List<Map<String, dynamic>> recipes;

  const RecipeListSearch({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shrinkWrap: true,
      physics:
          NeverScrollableScrollPhysics(), // Prevents gridview from scrolling independently
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Adjust the number of columns as needed
        crossAxisSpacing: 10, // Space between items in horizontal direction
        mainAxisSpacing: 10, // Space between items in vertical direction
        childAspectRatio: 0.75, // Adjust ratio to modify the size of each card
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];

        // Parse ingredients from Firestore document (ensure this structure is correct)
        final ingredients =
            (recipe['ingredients'] as List)
                .map((e) => Map<String, String>.from(e))
                .toList();

        // Parse steps from Firestore document (ensure this structure is correct)
        final steps =
            (recipe['steps'] as List)
                .map((e) => Map<String, dynamic>.from(e))
                .toList();

        // Returning the RecipeCard widget with the parsed data
        return RecipeCard(
          imageUrl: recipe["imageUrl"] ?? '',
          title: recipe["title"] ?? 'No Title',
          description: recipe["description"] ?? 'No description available',
          ingredients: ingredients,
          steps: steps,
          kcal:
              recipe["calories"]?.toString() ??
              '0', // Assuming calories field in Firestore
          time: recipe["time"] ?? '0 mins',
          name: recipe["name"] ?? 'Unknown Chef',
          avatarUrl: recipe["avatarUrl"] ?? '',
          likes: recipe["likes"]?.toString() ?? '0',
          isLiked: recipe["isLiked"] ?? false,
          recipeId: recipe["id"] ?? '',
        );
      },
    );
  }
}
