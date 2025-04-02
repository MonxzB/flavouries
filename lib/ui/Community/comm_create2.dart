import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/Community/comm_create3.dart';

class IngredientScreen extends StatefulWidget {
  final Map<String, dynamic> postData; // Dữ liệu từ Step 1

  IngredientScreen({required this.postData});

  @override
  _IngredientScreenState createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  List<Map<String, String>> ingredients = [
    {"name": "", "quantity": "", "unit": ""},
  ];

  // 📌 Thêm nguyên liệu mới
  void _addIngredient() {
    setState(() {
      ingredients.add({"name": "", "quantity": "", "unit": ""});
    });
  }

  // 📌 Xóa nguyên liệu (không xóa nếu chỉ còn 1)
  void _removeIngredient(int index) {
    setState(() {
      if (ingredients.length > 1) {
        ingredients.removeAt(index);
      }
    });
  }

  // 📌 Lưu danh sách nguyên liệu vào Firestore
  Future<void> _saveIngredients() async {
    try {
      // Lưu dữ liệu Step 1 vào Firestore
      DocumentReference postRef = await FirebaseFirestore.instance
          .collection("posts")
          .add(widget.postData);

      // Lưu danh sách nguyên liệu vào Subcollection "ingredients"
      for (var ingredient in ingredients) {
        if (ingredient["name"]!.isNotEmpty &&
            ingredient["quantity"]!.isNotEmpty &&
            ingredient["unit"]!.isNotEmpty) {
          await postRef.collection("ingredients").add(ingredient);
        }
      }

      // Chuyển sang Step 3 (RecipeStepsScreen)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeStepsScreen(postId: postRef.id),
        ),
      );
    } catch (e) {
      print("❌ Lỗi khi lưu nguyên liệu: $e");
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
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return _buildIngredientItem(index);
                },
              ),
            ),

            SizedBox(height: 10),

            // 🔹 Nút "Thêm nguyên liệu"
            Center(
              child: TextButton(
                onPressed: _addIngredient,
                style: TextButton.styleFrom(
                  side: BorderSide(color: Color(0xFF65A30D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                ),
                child: Text(
                  "Thêm nguyên liệu",
                  style: TextStyle(color: Color(0xFF65A30D), fontSize: 16),
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🔹 Nút "Hủy" & "Tiếp tục"
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

                // ✅ **Tiếp tục**
                ElevatedButton(
                  onPressed: _saveIngredients,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFABEB68),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  ),
                  child: Text("Tiếp tục"),
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
        "Nguyên liệu",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              "2/3",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // 📌 **Widget nhập nguyên liệu**
  Widget _buildIngredientItem(int index) {
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
                decoration: InputDecoration(
                  hintText: "Nhập nguyên liệu",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF65A30D)),
                  ),
                ),
                onChanged: (value) => ingredients[index]["name"] = value,
              ),
            ),

            if (index > 0)
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => _removeIngredient(index),
              ),
          ],
        ),

        SizedBox(height: 6),

        Row(
          children: [
            SizedBox(width: 50),

            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Định lượng",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF65A30D)),
                  ),
                ),
                onChanged: (value) => ingredients[index]["quantity"] = value,
              ),
            ),

            SizedBox(width: 10),

            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF65A30D)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                items:
                    ["Gram", "Kg", "ml", "L"]
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                onChanged: (value) => ingredients[index]["unit"] = value!,
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
      ],
    );
  }
}
