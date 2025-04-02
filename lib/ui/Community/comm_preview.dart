import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/Community/comm_home.dart';

class PostPreviewScreen extends StatefulWidget {
  final String postId;

  PostPreviewScreen({required this.postId});

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

  // 📌 Lấy dữ liệu từ Firestore
  Future<void> _fetchPostData() async {
    try {
      // Lấy dữ liệu bài viết chính
      DocumentSnapshot postSnapshot =
          await FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.postId)
              .get();

      if (!postSnapshot.exists) {
        print("⚠ Không tìm thấy bài viết!");
        return;
      }

      setState(() {
        postData = postSnapshot.data() as Map<String, dynamic>;
      });

      // Lấy danh sách nguyên liệu
      QuerySnapshot ingredientSnapshot =
          await FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.postId)
              .collection("ingredients")
              .get();

      setState(() {
        ingredients =
            ingredientSnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      });

      // Lấy danh sách bước làm
      QuerySnapshot stepsSnapshot =
          await FirebaseFirestore.instance
              .collection("posts")
              .doc(widget.postId)
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
                    // 🔹 Hình ảnh công thức
                    postData?["imageUrl"] != null &&
                            postData?["imageUrl"].isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            postData?["imageUrl"],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                        : SizedBox(),

                    SizedBox(height: 12),

                    // 🔹 Tiêu đề món ăn
                    Text(
                      postData?["dishName"] ?? "Không có tiêu đề",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // 🔹 Danh sách nguyên liệu
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

                    // 🔹 Công thức chế biến
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

                    // 🔹 Nút "Đăng"
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

  // 📌 **Hiển thị nguyên liệu**
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

  // 📌 **Hiển thị bước chế biến**
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

  // 📌 **Hiển thị Popup "Đăng bài thành công!"**
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
