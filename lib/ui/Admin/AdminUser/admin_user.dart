import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người dùng")),
      body: StreamBuilder<QuerySnapshot>(
        // Lấy dữ liệu người dùng và sắp xếp theo ngày tạo từ mới nhất đến cũ nhất
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .orderBy(
                  'created_at',
                  descending: true,
                ) // Sắp xếp người dùng mới nhất lên đầu
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi khi tải dữ liệu"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Không có người dùng"));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['avatar_url'] ?? ''),
                ),
                title: Text(user['name'] ?? 'Không có tên'),
                subtitle: Text(user['email'] ?? 'Không có email'),
                trailing: Text(user['role'] ?? 'Không có vai trò'),
                onLongPress: () {
                  // Hiển thị pop-up khi giữ lâu vào người dùng
                  _showDeleteDialog(context, user.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  // Hàm hiển thị pop-up xác nhận xóa người dùng
  void _showDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xóa người dùng'),
          content: Text('Bạn có chắc chắn muốn xóa người dùng này không?'),
          actions: [
            TextButton(
              onPressed: () {
                // Đóng pop-up
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xóa người dùng khi xác nhận
                _deleteUser(userId, context);
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  // Hàm xóa người dùng khỏi Firestore
  // Hàm xóa người dùng khỏi Firestore
  Future<void> _deleteUser(String userId, BuildContext context) async {
    try {
      // Xóa người dùng khỏi Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Đóng pop-up và hiển thị thông báo thành công
      Navigator.pop(context); // Đóng pop-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Người dùng đã được xóa thành công')),
      );
    } catch (e) {
      // Hiển thị thông báo lỗi nếu không thể xóa
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi xóa người dùng: $e')));
    }
  }
}
