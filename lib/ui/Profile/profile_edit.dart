import 'package:flutter/material.dart';
import 'package:fluttertest/ui/Profile/profile_user_edit.dart';

class SettingProfileScreen extends StatelessWidget {
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
          "Chỉnh sửa",
          style: TextStyle(
            color: Color(0xFF166534), // Màu xanh đậm
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟢 Hồ sơ người dùng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/images/avatar.png"),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nguyễn Văn X",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "nguyenvanx8386@gmail.com",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: () {
                    // Xử lý chỉnh sửa hồ sơ
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // 📌 Danh sách cài đặt
          _buildSettingItem(
            icon: Icons.person_outline,
            title: "Chỉnh sửa trang cá nhân",
            subtitle: "Thay đổi email, sở trường nấu ăn, tiểu sử",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: "Thông báo",
            subtitle: "Tin nhắn, lượt thích, bình luận",
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.language,
            title: "Ngôn ngữ",
            subtitle: "Tin nhắn, lượt thích, bình luận",
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.policy_outlined,
            title: "Điều khoản và chính sách",
            subtitle: "Tin nhắn, lượt thích, bình luận",
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.lock_outline,
            title: "Chế độ riêng tư",
            subtitle: "Tin nhắn, lượt thích, bình luận",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // 📌 Widget tạo một mục cài đặt
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}
