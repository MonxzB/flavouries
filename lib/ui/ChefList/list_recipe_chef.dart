import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/CardMostSearch/recipe_card.dart';

class RecipeListViewChef extends StatelessWidget {
  final String userId; // Lọc theo chefId

  const RecipeListViewChef({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('recipes')
              .where('user_id', isEqualTo: userId) // Lọc theo userID
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Kiểm tra xem có dữ liệu hay không
        if (snapshot.data?.docs.isEmpty ?? true) {
          return const Center(child: Text('No Recipes Found'));
        }

        final recipes =
            snapshot.data?.docs.map((doc) async {
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

              // Truy vấn thêm thông tin từ collection 'users' để lấy tên và avatar của người dùng
              final userId =
                  data['user_id']; // Assuming 'chef_id' maps to 'user_id'
              final userDoc =
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get();

              String userName = 'User Unknown';
              String userAvatar =
                  'https://i.pravatar.cc/100?u=$userId'; // Default image

              if (userDoc.exists) {
                final userData = userDoc.data() as Map<String, dynamic>;
                userName = userData['name'] ?? 'User Unknown';
                userAvatar = userData['avatar_url'] ?? userAvatar;
              }

              return {
                'imageUrl': data['image_url'] ?? '',
                'title': data['title'] ?? '',
                'description': data['description'] ?? '',
                'ingredients': ingredients,
                'steps': steps,
                'kcal': data['calories']?.toString() ?? '0',
                'time': '${steps.length} mins',
                'chefImage': userAvatar,
                'name': userName,
                'isLiked': false,
                'likes': '0',
                'id': doc.id,
              };
            }).toList();

        return SizedBox(
          height: 245,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(recipes!),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (futureSnapshot.hasError) {
                return Center(child: Text('Error: ${futureSnapshot.error}'));
              }

              final fetchedRecipes = futureSnapshot.data;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fetchedRecipes?.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final recipe = fetchedRecipes![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: RecipeCard(
                      imageUrl: recipe["imageUrl"] ?? '',
                      title: recipe["title"] ?? '',
                      description: recipe["description"] ?? '',
                      ingredients: recipe["ingredients"],
                      steps: recipe["steps"],
                      kcal: recipe["kcal"] ?? '0',
                      time: recipe["time"] ?? '0 mins',
                      avatarUrl: recipe["chefImage"] ?? '',
                      name: recipe["name"] ?? 'Unknown User',
                      userId: recipe["id"] ?? 'Unknown User', // Dùng id
                      isLiked: recipe["isLiked"] ?? false,
                      likes: recipe["likes"] ?? '0',
                      recipeId: recipe["id"] ?? '',
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
