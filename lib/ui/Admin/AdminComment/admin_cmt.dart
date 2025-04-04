import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCommentsScreen extends StatefulWidget {
  @override
  _AdminCommentsScreenState createState() => _AdminCommentsScreenState();
}

class _AdminCommentsScreenState extends State<AdminCommentsScreen> {
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
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
        var recipeId = doc['recipe_id']; // Lấy recipe_id từ bình luận
        var userId = doc['user_id']; // Lấy user_id từ bình luận

        // Kiểm tra và chuyển đổi recipe_id và user_id sang String nếu cần
        if (recipeId is int) recipeId = recipeId.toString();
        if (userId is int) userId = userId.toString();

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
            'comment': doc['comment'] ?? 'No comment', // Nội dung bình luận
            'recipeId': recipeId,
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
      });
    } catch (e) {
      print("Error fetching comments: $e");
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
            comments.isEmpty
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Loading nếu chưa lấy được dữ liệu
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
                            Text(comment['comment']), // Nội dung bình luận
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
