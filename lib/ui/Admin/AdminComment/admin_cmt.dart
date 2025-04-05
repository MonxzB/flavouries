import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCommentsScreen extends StatefulWidget {
  @override
  _AdminCommentsScreenState createState() => _AdminCommentsScreenState();
}

class _AdminCommentsScreenState extends State<AdminCommentsScreen> {
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments(); // Gọi hàm lấy dữ liệu bình luận
  }

  // Lấy danh sách bình luận từ Firebase
  Future<void> _fetchComments() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('recipe_comments').get();

      List<Map<String, dynamic>> commentList = [];
      for (var doc in snapshot.docs) {
        String content = doc['content'] ?? 'No comment';
        String recipeId = doc['recipe_id'] ?? 'No recipe ID';
        String userId = doc['user_id'] ?? 'No user ID';

        var recipeSnapshot =
            await FirebaseFirestore.instance
                .collection('recipes')
                .doc(recipeId)
                .get();

        var userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

        if (recipeSnapshot.exists && userSnapshot.exists) {
          commentList.add({
            'content': content,
            'recipeId': recipeId,
            'recipeTitle': recipeSnapshot['title'] ?? 'No Title',
            'userName': userSnapshot['name'] ?? 'Unknown User',
            'userAvatar':
                userSnapshot['avatar_url'] ?? 'https://via.placeholder.com/150',
            'commentId': doc.id, // Save the commentId for deletion
          });
        }
      }

      setState(() {
        comments = commentList;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching comments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Delete comment with a confirmation dialog
  Future<void> _deleteComment(String commentId) async {
    // Show confirmation dialog before deleting
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xóa bình luận"),
          content: Text("Bạn có chắc chắn muốn xóa bình luận này?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss dialog with 'No'
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss dialog with 'Yes'
              },
              child: Text("Xóa"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('recipe_comments')
            .doc(commentId) // Delete comment by its ID
            .delete();

        setState(() {
          comments.removeWhere((comment) => comment['commentId'] == commentId);
        });

        print("Đã xóa bình luận với ID: $commentId");
      } catch (e) {
        print("Lỗi khi xóa bình luận: $e");
      }
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
                ? Center(child: CircularProgressIndicator())
                : comments.isEmpty
                ? Center(child: Text("Không có bình luận."))
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
                          radius: 20,
                        ),
                        title: Text(comment['userName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['content']),
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteComment(comment['commentId']);
                          },
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
