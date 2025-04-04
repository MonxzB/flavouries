import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? userAvatar; // URL ảnh đại diện

  // Lấy dữ liệu người dùng từ Firestore khi màn hình được hiển thị
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Lấy dữ liệu người dùng từ Firestore
  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>;

          setState(() {
            _nameController.text = userData['name'] ?? ''; // Lấy tên người dùng
            _phoneController.text =
                userData['phone'] ?? ''; // Lấy số điện thoại
            _emailController.text = userData['email'] ?? ''; // Lấy email
            userAvatar = userData['avatar_url']; // Lấy ảnh đại diện
          });
        }
      } catch (e) {
        print("Lỗi khi lấy dữ liệu người dùng: $e");
      }
    }
  }

  // Cập nhật thông tin người dùng vào Firestore
  Future<void> _updateUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
              'name': _nameController.text,
              'phone': _phoneController.text,
              'email': _emailController.text,
              // 'avatar_url': userAvatar, // Nếu bạn muốn cập nhật ảnh đại diện
            });

        // Hiển thị thông báo khi cập nhật thành công
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Thông tin đã được cập nhật!")));

        // Quay lại màn hình trước
        Navigator.pop(context);
      } catch (e) {
        print("Lỗi khi cập nhật thông tin: $e");
      }
    }
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
          "Chỉnh sửa trang cá nhân",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // ✅ Bọc nội dung trong SingleChildScrollView để có thể cuộn
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 📌 Ảnh đại diện + Email
              _buildProfileHeader(),

              SizedBox(height: 20),

              // 📌 Các ô nhập liệu
              _buildTextField("Tên người dùng", _nameController),
              _buildTextField("Số điện thoại", _phoneController),
              _buildTextField("Email", _emailController),
              _buildTextField(
                "Password",
                _passwordController,
                isPassword: true,
              ),

              SizedBox(height: 30),

              // 📌 Nút hoàn tất chỉnh sửa
              ElevatedButton(
                onPressed: _updateUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF84CC16), // Màu xanh lá
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                ),
                child: Text(
                  "Hoàn tất chỉnh sửa",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              SizedBox(height: 20), // Thêm khoảng cách để tránh bị che khuất
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Widget Header (Ảnh đại diện + Email)
  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage:
              userAvatar != null
                  ? NetworkImage(userAvatar!) // Lấy ảnh từ Firestore nếu có
                  : AssetImage("assets/images/avatar.png") as ImageProvider,
        ),
        SizedBox(height: 10),
        Text(
          _nameController.text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          _emailController.text,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // 📌 Widget ô nhập liệu
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Color(0xFF65A30D),
                ), // Viền xanh lá
              ),
            ),
          ),
        ],
      ),
    );
  }
}
