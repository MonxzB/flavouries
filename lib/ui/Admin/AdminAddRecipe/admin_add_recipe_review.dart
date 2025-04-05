import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/ui/Admin/admin_home.dart';
import 'package:fluttertest/ui/Community/comm_home.dart';

class AdminAddRecipeReview extends StatefulWidget {
  final String recipeId;

  AdminAddRecipeReview({required this.recipeId});

  @override
  _AdminAddRecipeReviewState createState() => _AdminAddRecipeReviewState();
}

class _AdminAddRecipeReviewState extends State<AdminAddRecipeReview> {
  Map<String, dynamic>? postData;
  List<Map<String, dynamic>> ingredients = [];
  List<Map<String, dynamic>> steps = [];

  @override
  void initState() {
    super.initState();
    _fetchPostData();
  }

  // 📌 Fetch data from Firestore
  Future<void> _fetchPostData() async {
    try {
      // Get the main recipe data
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(widget.recipeId)
              .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        // Fetch ingredients from the "ingredients" field
        ingredients = List<Map<String, dynamic>>.from(
          data['ingredients'] ?? [],
        );

        // Fetch steps from the "steps" field
        steps = List<Map<String, dynamic>>.from(data['steps'] ?? []);

        setState(() {
          postData = data;
        });
        print("data: $postData ");
      } else {
        print("⚠ Không có dữ liệu bài viết!");
      }
    } catch (e) {
      print("❌ Lỗi khi lấy dữ liệu bài viết: $e");
    }
  }

  // 📌 Lưu bài viết với user_id
  Future<void> _submitPost() async {
    try {
      // Lấy user_id từ Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Thêm user_id vào dữ liệu bài viết
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .update({
            'user_id': userId, // Lưu user_id vào bài viết
          });

      // Hiển thị thông báo thành công
      _showSuccessPopup(context);
    } catch (e) {
      print("❌ Lỗi khi lưu user_id vào bài viết: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body:
          postData == null
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post image
                    postData?["image_url"] != null &&
                            postData?["image_url"].isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            postData?["image_url"] ??
                                'https://via.placeholder.com/150',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                        : SizedBox(),

                    SizedBox(height: 12),

                    // Dish name
                    Text(
                      postData?["title"] ?? "Không có tiêu đề",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Ingredients list
                    Text(
                      "Nguyên liệu",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    ingredients.isEmpty
                        ? Text("Không có nguyên liệu.")
                        : Column(
                          children:
                              ingredients.map((ingredient) {
                                return _buildIngredientItem(
                                  ingredient["name"] ?? "N/A",
                                  ingredient["quantity"] ?? "N/A",
                                );
                              }).toList(),
                        ),

                    SizedBox(height: 12),

                    // Recipe steps
                    Text(
                      "Công thức",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    steps.isEmpty
                        ? Text("Không có bước chế biến.")
                        : Column(
                          children:
                              steps.map((step) {
                                return _buildStep(
                                  step["step_number"] ?? 0,
                                  step["description"] ?? "Không có mô tả",
                                  step["image_url"] ?? '',
                                );
                              }).toList(),
                        ),

                    SizedBox(height: 20),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF84CC16),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 14,
                          ),
                        ),
                        child: Text("Đăng"),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  // 📌 **AppBar**
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Bài viết",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  // 📌 **Ingredient Item**
  Widget _buildIngredientItem(String name, String quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 14)),
          Text(
            "SL: $quantity",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 📌 **Step Item**
  Widget _buildStep(int stepNumber, String description, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$stepNumber. Bước $stepNumber",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          SizedBox(height: 6),
          imageUrl.isNotEmpty
              ? Image.network(
                imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              )
              : SizedBox(),
        ],
      ),
    );
  }

  // 📌 **Success Popup**
  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                SizedBox(height: 16),
                Text(
                  "Đăng bài thành công!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng Popup
                    // Sử dụng pushNamed thay vì pushNamedAndRemoveUntil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                AdminHome(), // Quay lại FlavouriesScreen
                      ),
                    );
                  },
                  child: Text("Về trang chủ"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
