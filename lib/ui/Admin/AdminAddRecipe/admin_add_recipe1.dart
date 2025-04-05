import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/Community/comm_create2.dart';

class AdminAddRecipe1 extends StatefulWidget {
  @override
  _AdminAddRecipe1State createState() => _AdminAddRecipe1State();
}

class _AdminAddRecipe1State extends State<AdminAddRecipe1> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image; // Ảnh đã chọn

  // 📌 Chọn ảnh từ Gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // 📌 Tải ảnh lên Firebase Storage
  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      // 🔹 Generate a unique filename
      String fileName = "recipes/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // 🔹 Upload file
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // 🔹 Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      // 🔹 Get the download URL after successful upload
      if (snapshot.state == TaskState.success) {
        String downloadUrl = await snapshot.ref.getDownloadURL();
        print("✅ Ảnh đã tải lên thành công: $downloadUrl");
        return downloadUrl;
      } else {
        print("❌ Lỗi: Không thể lấy URL sau khi tải ảnh lên.");
        return null;
      }
    } catch (e) {
      print("❌ Lỗi khi tải ảnh lên Firebase: $e");
      return null;
    }
  }

  // 📌 Chuyển sang màn IngredientScreen
  void _nextStep() async {
    String content = _postController.text.trim();
    String title = _dishNameController.text.trim();
    String description = _descriptionController.text.trim();

    // Kiểm tra nếu thiếu dữ liệu
    if (content.isEmpty || title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin!")),
      );
      return;
    }

    // Tải ảnh lên Firebase nếu có
    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImageToFirebase(_image!);
    }

    // Tạo dữ liệu để chuyển sang Step 2
    Map<String, dynamic> postData = {
      'content': content,
      'title': title,
      'description': description,
      'image_url': imageUrl ?? "",
    };

    // Chuyển sang màn IngredientScreen (Step 2)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IngredientScreen(postData: postData),
      ),
    );
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
            _buildTextField(
              "Hãy nói gì đó",
              "Bạn muốn chia sẻ",
              _postController,
            ),
            SizedBox(height: 6),
            Text(
              "Nếu bạn không chia sẻ công thức, hãy nhấn tiếp tục để đăng bài viết nhé!",
              style: TextStyle(fontSize: 12, color: Color(0xff446E26)),
            ),
            SizedBox(height: 16),
            _buildTextField(
              "Tên món ăn",
              "Nhập tên món ăn",
              _dishNameController,
            ),
            SizedBox(height: 16),
            _buildImagePicker(),
            SizedBox(height: 16),
            _buildTextField(
              "Mô tả món ăn",
              "Mô tả món ăn của bạn",
              _descriptionController,
              maxLines: 3,
            ),
            Spacer(),
            _buildBottomButtons(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 📌 AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Tạo bài viết",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              "1/3",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // 📌 Widget tạo ô nhập
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Color(0xff355321)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  // 📌 Widget chọn ảnh/video
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Thêm ảnh/video",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff355321),
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child:
                _image == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 40, color: Color(0xff73746B)),
                        SizedBox(height: 6),
                        Text(
                          "Thêm ảnh/video",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff9FA196),
                          ),
                        ),
                      ],
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(
                        _image!,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  // 📌 Nút Hủy & Tiếp tục
  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Hủy"),
        ),
        ElevatedButton(onPressed: _nextStep, child: Text("Tiếp tục")),
      ],
    );
  }
}
