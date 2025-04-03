import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/Community/comm_home.dart';

class PostPreviewScreen extends StatefulWidget {
  final String recipeId;

  PostPreviewScreen({required this.recipeId});

  @override
  _PostPreviewScreenState createState() => _PostPreviewScreenState();
}

class _PostPreviewScreenState extends State<PostPreviewScreen> {
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
      // Get the main post data
      DocumentSnapshot postSnapshot =
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(widget.recipeId)
              .get();

      if (!postSnapshot.exists) {
        print("⚠ Không tìm thấy bài viết!");
        return;
      }

      setState(() {
        postData = postSnapshot.data() as Map<String, dynamic>;
      });

      // Get ingredients data
      QuerySnapshot ingredientSnapshot =
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(widget.recipeId)
              .collection("ingredients")
              .get();

      setState(() {
        ingredients =
            ingredientSnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      });

      // Get recipe steps data
      QuerySnapshot stepsSnapshot =
          await FirebaseFirestore.instance
              .collection("recipes")
              .doc(widget.recipeId)
              .collection("steps")
              .orderBy("step_number")
              .get();

      setState(() {
        steps =
            stepsSnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      });
    } catch (e) {
      print("❌ Lỗi khi lấy dữ liệu bài viết: $e");
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
                    postData?["imageUrl"] != null &&
                            postData?["imageUrl"].isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            postData?["imageUrl"] ??
                                'https://via.placeholder.com/150', // Fallback image
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                        : SizedBox(),

                    SizedBox(height: 12),

                    // Dish name
                    Text(
                      postData?["dishName"] ?? "Không có tiêu đề",
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
                              ingredients
                                  .map(
                                    (ingredient) => _buildIngredientItem(
                                      ingredient["ingredient"] ?? "N/A",
                                      ingredient["quantity"] ?? "N/A",
                                    ),
                                  )
                                  .toList(),
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
                              steps
                                  .map(
                                    (step) => _buildStep(
                                      step["step_number"] ?? 0,
                                      step["description"] ?? "Không có mô tả",
                                      step["imageUrl"] ?? "",
                                    ),
                                  )
                                  .toList(),
                        ),

                    SizedBox(height: 20),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _showSuccessPopup(context),
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
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
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
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlavouriesScreen(),
                      ),
                      (route) => false,
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
