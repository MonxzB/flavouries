import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/CardFearture/recipe_card2.dart';

class ListCard2 extends StatefulWidget {
  const ListCard2({Key? key}) : super(key: key);

  @override
  State<ListCard2> createState() => _ListCard2State();
}

class _ListCard2State extends State<ListCard2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('recipes')
              .snapshots(), // Sử dụng snapshots để nhận dữ liệu theo thời gian thực
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Không có công thức nào!'),
          ); // Thông báo nếu không có dữ liệu
        }

        // Lấy dữ liệu từ snapshot và map thành list recipes
        final recipes =
            snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              final ingredients =
                  (data['ingredients'] as List?)
                      ?.map((e) => Map<String, String>.from(e))
                      .toList() ??
                  [];

              final steps =
                  (data['steps'] as List?)
                      ?.map((e) => Map<String, dynamic>.from(e))
                      .toList() ??
                  [];

              return {
                'id': doc.id,
                'imageUrl': data['image_url'] ?? '',
                'title': data['title'] ?? '',
                'description': data['description'] ?? '',
                'ingredients': ingredients,
                'steps': steps,
                'kcal': data['calories']?.toString() ?? '0',
                'time': '${steps.length} mins',
                'avatar_url': 'https://i.pravatar.cc/100?u=${data['user_id']}',
                'name': 'Chef ${data['user_id'] ?? 'Unknown'}',
                'isLiked': false,
                'likes': 0,
              };
            }).toList();

        // Hiển thị dữ liệu
        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
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
                  name: recipe["name"],
                  avatar_url: recipe["avatar_url"],
                  likes: recipe["likes"],
                  isLiked: recipe["isLiked"],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
