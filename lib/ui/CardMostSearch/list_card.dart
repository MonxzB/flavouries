import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe_card.dart';

class RecipeListView extends StatefulWidget {
  const RecipeListView({Key? key}) : super(key: key);

  @override
  _RecipeListViewState createState() => _RecipeListViewState();
}

class _RecipeListViewState extends State<RecipeListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Recipes Found'));
        }

        // Lấy dữ liệu từ snapshot và map thành list recipes
        final recipes =
            snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              // Đảm bảo rằng ingredients và steps có dữ liệu mặc định nếu null
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

              final userId = data['user_id'];
              print("user_id: $data");
              return FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId.toString())
                  .get()
                  .then((userSnapshot) {
                    if (userSnapshot.exists) {
                      final userData =
                          userSnapshot.data() as Map<String, dynamic>;

                      final userName = userData['name'] ?? 'User Unknown';
                      final userImage =
                          userData['avatar_url'] ??
                          'https://firebasestorage.googleapis.com/v0/b/your-project-id.appspot.com/o/default_chef_image.jpg?alt=media'; // Lấy đúng avatar_url từ userData

                      return {
                        'imageUrl': data['image_url'] ?? '',
                        'title': data['title'] ?? '',
                        'description': data['description'] ?? '',
                        'ingredients': ingredients,
                        'steps': steps,
                        'kcal': data['calories']?.toString() ?? '0',
                        'time': '${steps.length} mins',
                        'userImage':
                            userImage, // Sử dụng avatar_url từ userData
                        'name': userName, // Sử dụng tên từ userData
                        'isLiked': false,
                        'likes': '0',
                        'id': doc.id,
                      };
                    } else {
                      return {
                        'imageUrl': data['image_url'] ?? '',
                        'title': data['title'] ?? '',
                        'description': data['description'] ?? '',
                        'ingredients': ingredients,
                        'steps': steps,
                        'kcal': data['calories']?.toString() ?? '0',
                        'time': '${steps.length} mins',
                        'userImage':
                            'https://i.pravatar.cc/100?u=$userId', // URL mặc định nếu không tìm thấy user
                        'name':
                            'User Unknown', // Tên mặc định nếu không tìm thấy user
                        'isLiked': false,
                        'likes': '0',
                        'id': doc.id,
                      };
                    }
                  });
            }).toList();

        // Hiển thị dữ liệu
        return SizedBox(
          height: 245,
          child: FutureBuilder(
            future: Future.wait(recipes),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (futureSnapshot.hasError) {
                return Center(child: Text('Error: ${futureSnapshot.error}'));
              }

              final fetchedRecipes =
                  futureSnapshot.data as List<Map<String, dynamic>>?;

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
                      avatarUrl: recipe["userImage"] ?? '', // Dùng userImage
                      name: recipe["name"] ?? 'Unknown User', // Dùng name
                      userId: recipe["userId"] ?? 'Unknown User', // Dùng id
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
