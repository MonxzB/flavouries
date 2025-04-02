import 'package:flutter/material.dart';

class TopRecipeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final List<String> ingredients;
  final String category;
  final String time;
  final bool isFavorite;
  final String ranking;
  final int likes;

  const TopRecipeCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.ingredients,
    required this.category,
    required this.time,
    required this.isFavorite,
    required this.ranking,
    required this.likes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // ✅ Độ rộng tối ưu
      height: 270, // ✅ Độ cao card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage("assets/images/food1.png"), // ✅ Đường dẫn ảnh đúng
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // ✅ Overlay giúp chữ dễ đọc
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),

          // 🔥 Badge "Top 1"
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ranking,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // ❤️ Like Button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${likes}k", // ✅ Hiển thị số like
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // 🍜 Tiêu đề món ăn
          Positioned(
            bottom: 70,
            left: 10,
            right: 10,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 🏷️ Nguyên liệu chính
          Positioned(
            bottom: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                for (
                  var i = 0;
                  i < (ingredients.length > 2 ? 2 : ingredients.length);
                  i++
                )
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        ingredients[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                if (ingredients.length > 2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "+${ingredients.length - 2}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          // 🍲 Loại món & Thời gian
          Positioned(
            bottom: 10,
            left: 10,
            child: Row(
              children: [
                Text(
                  category,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 8),
                const Text(
                  "·",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
