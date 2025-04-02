import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "Nguyễn Văn X",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "0123456789",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "nguyenvanx8386@gmail.com",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "************",
  );

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
                onPressed: () {
                  // TODO: Xử lý cập nhật thông tin
                  print("Hoàn tất chỉnh sửa");
                  Navigator.pop(context); // Quay lại trang trước
                },
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
          backgroundImage: AssetImage("assets/images/avatar.png"),
        ),
        SizedBox(height: 10),
        Text(
          "Nguyễn Văn X",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "nguyenvanx8386@gmail.com",
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
