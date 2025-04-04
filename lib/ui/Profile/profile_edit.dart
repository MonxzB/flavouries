import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Đảm bảo đã import firebase_auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/Screens/Login/login_screen.dart';
import 'package:fluttertest/ui/Profile/profile_user_edit.dart'; // Đảm bảo đã import cloud_firestore

class SettingProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin người dùng hiện tại từ FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

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
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi khi lấy dữ liệu"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Không có dữ liệu người dùng"));
          }

          // Lấy dữ liệu người dùng từ Firestore
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          String? userName = userData['name'] ?? "Nguyễn Văn X";
          String? userEmail = user?.email ?? "nguyenvanx8386@gmail.com";
          String? userAvatar =
              userData['avatar_url'] ??
              "https://firebasestorage.googleapis.com/v0/b/flavouries-b202d.firebasestorage.app/o/posts%2F1741919637126.jpg?alt=media&token=c188ccd6-c1f7-4870-ba20-f6bac10c271b"; // Default avatar if no avatar

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 Hồ sơ người dùng
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          userAvatar != null
                              ? NetworkImage(
                                userAvatar!,
                              ) // Nếu userAvatar không null, sử dụng nó
                              : null, // Nếu userAvatar là null, thì không sử dụng ảnh
                      backgroundColor: Colors.grey.shade300,
                    ),

                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName ?? "Nguyễn Văn X",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userEmail ?? "nguyenvanx8386@gmail.com",
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
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                  // Navigate to edit profile screen
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
              _buildSettingItem(
                icon: Icons.logout_outlined,
                title: "Đăng xuất",
                subtitle: "Đăng xuất khỏi ứng dụng",
                onTap: () {
                  _handleLogout(context); // Xử lý sự kiện đăng xuất
                },
              ),
            ],
          );
        },
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

  // 📌 Xử lý đăng xuất
  void _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Đăng xuất khỏi Firebase

      // Điều hướng về màn hình đăng nhập
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ), // Điều hướng về màn hình đăng nhập
      );
    } catch (e) {
      print("❌ Lỗi khi đăng xuất: $e");
      // Có thể hiển thị thông báo lỗi cho người dùng ở đây nếu cần
    }
  }
}
