import 'package:flutter/material.dart';
import 'package:fluttertest/ui/TopReceipes/top_recipe.dart';

class ListTopRecipe extends StatelessWidget {
  const ListTopRecipe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> topRecipes = [
      {
        "imageUrl": "assets/images/bun_rieu.png",
        "title": "Bún riêu cua tóp mỡ full topping",
        "ingredients": ["Riêu cua", "Trứng vịt", "+8"],
        "category": "Món canh",
        "time": "30 phút",
        "isFavorite": true,
        "ranking": "Top 1",
        "likes": 3000, // ✅ Đổi từ "3k" thành số nguyên
      },
      {
        "imageUrl": "assets/images/pho_bo.png",
        "title": "Phở bò truyền thống Hà Nội",
        "ingredients": ["Thịt bò", "Bánh phở", "+5"],
        "category": "Món nước",
        "time": "45 phút",
        "isFavorite": false,
        "ranking": "Top 2",
        "likes": 2500, // ✅ Đổi từ "2.5k" thành số nguyên
      },
      {
        "imageUrl": "assets/images/banh_xeo.png",
        "title": "Bánh xèo miền Tây",
        "ingredients": ["Bột gạo", "Tôm", "+6"],
        "category": "Món chiên",
        "time": "40 phút",
        "isFavorite": true,
        "ranking": "Top 3",
        "likes": 2000, // ✅ Đổi từ "2k" thành số nguyên
      },
    ];

    return SizedBox(
      height: 280, // ✅ Tăng chiều cao để tránh lỗi overflow
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topRecipes.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 10 : 0, // ✅ Khoảng cách trái cho item đầu
              right: 10, // ✅ Khoảng cách giữa các card
            ),
            child: TopRecipeCard(
              imageUrl: topRecipes[index]["imageUrl"],
              title: topRecipes[index]["title"],
              ingredients: List<String>.from(topRecipes[index]["ingredients"]),
              category: topRecipes[index]["category"],
              time: topRecipes[index]["time"],
              isFavorite: topRecipes[index]["isFavorite"],
              ranking: topRecipes[index]["ranking"],
              likes: topRecipes[index]["likes"], // ✅ Truyền `int`
            ),
          );
        },
      ),
    );
  }
}
