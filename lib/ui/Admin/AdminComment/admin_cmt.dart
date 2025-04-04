import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCommentsScreen extends StatefulWidget {
  @override
  _AdminCommentsScreenState createState() => _AdminCommentsScreenState();
}

class _AdminCommentsScreenState extends State<AdminCommentsScreen> {
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true; // Thêm biến để kiểm tra trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    _fetchComments(); // Gọi hàm lấy dữ liệu bình luận
  }

  // Lấy danh sách bình luận từ Firebase
  Future<void> _fetchComments() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance
              .collection('recipe_comments')
              .get(); // Lấy tất cả bình luận từ collection 'recipe_comments'

      List<Map<String, dynamic>> commentList = [];
      for (var doc in snapshot.docs) {
        String content = doc['content'] ?? 'No comment';
        String recipeId = doc['recipe_id'] ?? 'No recipe ID';
        String userId = doc['user_id'] ?? 'No user ID';

        // In ra bình luận để kiểm tra
        print("Bình luận: $content, Recipe ID: $recipeId, User ID: $userId");

        // Lấy dữ liệu công thức từ bảng recipes
        var recipeSnapshot =
            await FirebaseFirestore.instance
                .collection('recipes')
                .doc(recipeId)
                .get();

        // Lấy dữ liệu người dùng từ bảng users
        var userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

        if (recipeSnapshot.exists && userSnapshot.exists) {
          commentList.add({
            'content': content, // Nội dung bình luận
            'recipeId': recipeId, // ID công thức
            'recipeTitle':
                recipeSnapshot['title'] ?? 'No Title', // Tiêu đề công thức
            'userName':
                userSnapshot['name'] ?? 'Unknown User', // Tên người dùng
            'userAvatar':
                userSnapshot['avatar_url'] ??
                'https://via.placeholder.com/150', // Avatar người dùng
          });
        }
      }

      setState(() {
        comments = commentList;
        isLoading = false; // Đánh dấu đã tải xong dữ liệu
      });
    } catch (e) {
      print("Error fetching comments: $e");
      setState(() {
        isLoading = false; // Đánh dấu khi có lỗi
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Bình luận',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator()) // Hiển thị loading
                : comments.isEmpty
                ? Center(
                  child: Text("Không có bình luận."),
                ) // Thông báo nếu không có bình luận
                : ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment['userAvatar']),
                          radius: 20, // Kích thước avatar
                        ),
                        title: Text(comment['userName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['content']), // Nội dung bình luận
                            SizedBox(height: 5),
                            Text(
                              'Công thức: ${comment['recipeTitle']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
