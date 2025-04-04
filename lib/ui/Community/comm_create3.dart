import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/Community/comm_home.dart';
import 'package:fluttertest/ui/Community/comm_preview.dart';

class RecipeStepsScreen extends StatefulWidget {
  final String recipeId; // Nhận postId từ Step 2

  RecipeStepsScreen({required this.recipeId});

  @override
  _RecipeStepsScreenState createState() => _RecipeStepsScreenState();
}

class _RecipeStepsScreenState extends State<RecipeStepsScreen> {
  List<Map<String, dynamic>> steps = [
    {"description": ""},
  ];

  // 📌 Thêm bước mới
  void _addStep() {
    setState(() {
      steps.add({"description": ""});
    });
  }

  // 📌 Xóa bước
  void _removeStep(int index) {
    setState(() {
      if (steps.length > 1) {
        steps.removeAt(index);
      }
    });
  }

  // 📌 Lưu danh sách bước làm vào Firestore
  Future<void> _saveRecipeSteps() async {
    try {
      // Lấy tài liệu `recipe` mà bạn đã tạo ở bước 1
      DocumentReference recipeRef = FirebaseFirestore.instance
          .collection("recipes")
          .doc(widget.recipeId);

      // Lưu danh sách bước chế biến vào trường "steps" của tài liệu `recipe`
      await recipeRef.update({
        'steps': steps, // Các bước chế biến từ mảng `steps`
      });

      // Chuyển sang màn xem trước bài viết (PostPreviewScreen)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostPreviewScreen(recipeId: widget.recipeId),
        ),
      );
    } catch (e) {
      print("❌ Lỗi khi lưu bước chế biến: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return _buildStepItem(index);
                },
              ),
            ),

            SizedBox(height: 10),

            // 🔹 Nút "Thêm bước"
            Center(
              child: TextButton(
                onPressed: _addStep,
                style: TextButton.styleFrom(
                  side: BorderSide(color: Color(0xFF65A30D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                child: Text(
                  "Thêm bước",
                  style: TextStyle(color: Color(0xFF65A30D), fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🔹 Nút "Hủy" & "Hoàn tất"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔙 **Hủy**
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFFBABCB5), width: 1.5),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 14),
                  ),
                  child: Text("Hủy"),
                ),

                // ✅ **Hoàn tất**
                ElevatedButton(
                  onPressed: _saveRecipeSteps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFABEB68),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  ),
                  child: Text("Hoàn tất"),
                ),
              ],
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
        "Công thức",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              "3/3",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // 📌 **Widget nhập bước làm**
  Widget _buildStepItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.black,
              child: Text(
                "${index + 1}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10),

            Icon(Icons.drag_indicator, color: Colors.grey),
            SizedBox(width: 10),

            Expanded(
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Nhập bước chế biến",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF65A30D)),
                  ),
                ),
                onChanged: (value) => steps[index]["description"] = value,
              ),
            ),

            if (index > 0)
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => _removeStep(index),
              ),
          ],
        ),

        SizedBox(height: 6),

        // 🔹 Nút chọn ảnh
        SizedBox(height: 10),
      ],
    );
  }
}
