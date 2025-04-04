import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/ui/CardMostSearch/list_card.dart';
import 'package:fluttertest/ui/Detail/detail_video.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  final String imageUrl;
  final String title;
  final String description;
  final String kcal;
  final String time;
  final bool isLiked;
  final List<Map<String, String>> ingredients;
  final List<Map<String, dynamic>> steps;

  const RecipeDetailScreen({
    Key? key,
    required this.recipeId,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.kcal,
    required this.time,
    required this.isLiked,
    required this.ingredients,
    required this.steps,
  }) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isLiked = false;
  late TabController _tabController;
  late String userId;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    _tabController = TabController(length: 2, vsync: this);
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<void> _toggleLike() async {
    try {
      final favouriteRef = FirebaseFirestore.instance.collection('favourites');

      if (isLiked) {
        await favouriteRef
            .where('user_id', isEqualTo: userId)
            .where('recipe_id', isEqualTo: int.parse(widget.recipeId))
            .get()
            .then((snapshot) {
              snapshot.docs.forEach((doc) {
                doc.reference.delete();
              });
            });
      } else {
        await favouriteRef.add({
          'user_id': userId,
          'recipe_id': int.parse(widget.recipeId),
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      setState(() {
        isLiked = !isLiked;
      });
    } catch (e) {
      print("Error adding/removing like: $e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Công thức",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.black,
            ),
            onPressed: _toggleLike,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh công thức
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(widget.imageUrl, width: 200, height: 110),
              ),
            ),
            const SizedBox(height: 20),

            // Tiêu đề và mô tả công thức
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Thông tin dinh dưỡng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: nutritionInfo(widget.kcal, "Kcal")),
                  _buildDivider(),
                  Expanded(child: nutritionInfo(widget.time, "Phút")),
                  _buildDivider(),
                  Expanded(child: nutritionInfo("10g", "Protein")),
                  _buildDivider(),
                  Expanded(child: nutritionInfo("15g", "Carbs")),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Tab cho Nguyên liệu và Các bước
            Container(
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: Color(0xFF65A30D),
                tabs: [Tab(text: "Nguyên liệu"), Tab(text: "Các bước")],
              ),
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [_buildIngredientsList(), _buildStepsList()],
              ),
            ),

            // Gợi ý công thức khác
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ), // Lề trái 16px cho tiêu đề
                    child: Text(
                      "Gợi ý công thức khác",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      child: RecipeListView(), // Thêm RecipeListView vào
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Nút xem video
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => RecipeVideoScreen(recipeId: widget.recipeId),
              ),
            );
          },
          backgroundColor: Color(0xff65A30D),
          icon: Icon(Icons.play_arrow, color: Color(0xffffffff)),
          label: Text(
            "Xem video",
            style: TextStyle(fontSize: 14, color: Color(0xffffffff)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget nutritionInfo(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF65A30D),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF585951))),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 20, color: Color(0xFF9FA196));
  }

  Widget _buildIngredientsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = widget.ingredients[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    ingredient["image"] ?? "assets/images/nguyenlieu.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ingredient["name"] ?? "Không rõ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF166534),
                    ),
                  ),
                ),
                Text(
                  ingredient["quantity"] ?? "--",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        final step = widget.steps[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.green,
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step["description"] ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
