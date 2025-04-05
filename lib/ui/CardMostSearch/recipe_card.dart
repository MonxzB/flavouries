import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/CardMostSearch/detail_chef1.dart';
import 'package:fluttertest/ui/ChefList/detail_chef.dart';
import 'package:fluttertest/ui/Detail/detail_recipe.dart'; // Import Firestore

class RecipeCard extends StatelessWidget {
  final String recipeId;
  final String imageUrl;
  final String title;
  final String description;
  final List<Map<String, String>> ingredients;
  final List<Map<String, dynamic>> steps;
  final String kcal;
  final String time;
  final String avatarUrl;
  final String name;
  final String user_id; // user_id từ Firestore
  final bool isLiked;
  final String likes;

  const RecipeCard({
    Key? key,
    required this.recipeId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.kcal,
    required this.time,
    required this.avatarUrl,
    required this.name,
    required this.user_id, // Truyền user_id
    required this.isLiked,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // In ra user_id để kiểm tra
        print('Received user_id: $user_id'); // Kiểm tra user_id đã nhận

        // Điều hướng đến RecipeDetailScreen khi nhấn vào công thức
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RecipeDetailScreen(
                  recipeId: recipeId,
                  imageUrl: imageUrl,
                  title: title,
                  description: description,
                  ingredients: ingredients,
                  steps: steps,
                  kcal: kcal,
                  time: time,
                  isLiked: isLiked,
                ),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh công thức
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                width: 200,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                spacing: 3,
                runSpacing: 3,
                children:
                    ingredients
                        .take(2)
                        .map(
                          (ingredient) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Color(0xff000000).withOpacity(0.4),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ingredient["name"] ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    kcal,
                    style: TextStyle(fontSize: 12, color: Color(0xff42423D)),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.access_time, color: Colors.orange, size: 14),
                  SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Color(0xff42423D)),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[300], height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print(
                        'user_id: $user_id',
                      ); // In ra user_id trước khi điều hướng

                      // Điều hướng đến ChefProfileScreen khi nhấn vào avatar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChefProfileScreen1(
                                name: name, // Truyền name
                                imageUrl: avatarUrl, // Truyền avatarUrl
                              ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        avatarUrl ??
                            'https://via.placeholder.com/150', // Avatar mặc định
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
