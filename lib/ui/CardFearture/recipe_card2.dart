import 'package:flutter/material.dart';
import 'package:fluttertest/ui/Detail/detail_recipe.dart';

class RecipeCard2 extends StatelessWidget {
  final String recipeId;
  final String imageUrl;
  final String title;
  final String description;
  final List<Map<String, String>> ingredients;
  final List<Map<String, dynamic>> steps;
  final String kcal;
  final String time;
  final String name;
  final String avatar_url;
  final bool isLiked;
  final int likes; // ✅ Đổi từ String => int

  const RecipeCard2({
    Key? key,
    required this.recipeId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.kcal,
    required this.time,
    required this.name,
    required this.avatar_url,
    required this.likes,
    required this.isLiked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => RecipeDetailScreen(
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
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Like overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    imageUrl,
                    width: 180,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _formatLikes(likes),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff355321),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Calories & Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 14,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 4),
                  Text(
                    kcal,
                    style: TextStyle(fontSize: 12, color: Color(0xff42423D)),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.access_time, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 12, color: Color(0xff42423D)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLikes(int likes) {
    if (likes >= 1000) {
      return "${(likes / 1000).toStringAsFixed(1)}k";
    }
    return likes.toString();
  }
}
