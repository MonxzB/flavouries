import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentScreen extends StatefulWidget {
  final Map<String, dynamic> postData;

  const CommentScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  // Fetch the comments for the post from Firestore
  Stream<QuerySnapshot> getComments() {
    return FirebaseFirestore.instance
        .collection('recipe_comments')
        .where(
          'recipe_id',
          isEqualTo: widget.postData['id'],
        ) // Assuming post_id field exists in comments
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // Add a new comment to Firestore
  void _addComment(String text) async {
    if (text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('recipe_comments').add({
        'recipe_id': widget.postData['id'],
        'user_id':
            1, // Add the user ID here, or use authentication to get the user
        'content': text,
        'image_url': '', // Optionally, you can add an image
        'created_at': Timestamp.now(), // Current timestamp
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Bình luận",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔹 Danh sách bình luận (comments)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getComments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi khi tải bình luận!"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Chưa có bình luận nào!"));
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var commentData =
                        comments[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text(
                                commentData["name"] ?? "Anonymous",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                commentData["time"] ?? "Now",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            commentData["content"] ?? "No Content",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          // Optional: Display image if available
                          if (commentData.containsKey("image_url") &&
                              commentData["image_url"] != "")
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  commentData["image_url"]!,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          SizedBox(height: 4),

                          // ❤️ Like Button
                          Row(
                            children: [
                              Icon(
                                Icons.favorite_border,
                                color: Color(0xff42423D),
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text("Thích", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 Ô nhập bình luận
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Viết bình luận...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Color(0xffBABCB5)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _addComment(_commentController.text),
                  child: Icon(Icons.send, color: Color(0xff65A30D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
