import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;

  PostDetailScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chi tiết bài viết",
          style: TextStyle(color: Color(0xff21330F)),
        ),
        iconTheme: IconThemeData(color: Color(0xff21330F)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('recipes').doc(postId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi khi tải bài viết"));
          }

          if (!snapshot.hasData) {
            return Center(child: Text("Không có dữ liệu"));
          }

          var postData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh bài viết
                  postData['image_url'] != null
                      ? Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            postData['image_url'],
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      : SizedBox(),

                  SizedBox(height: 16),

                  // Tên món ăn
                  Center(
                    child: Text(
                      postData['title'] ?? 'Không có tiêu đề',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff111907),
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Nguyên liệu
                  Text(
                    "Nguyên liệu:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (postData['ingredients'] as List).length,
                    itemBuilder: (context, index) {
                      var ingredient = postData['ingredients'][index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  ingredient["image"] ??
                                      "assets/images/nguyenlieu.png",
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  ingredient["name"] ?? "Không rõ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                              ),
                              Text(
                                ingredient["quantity"] ?? "--",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),

                  // Công thức
                  Text(
                    "Công thức:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: (postData['steps'] as List).length,
                    itemBuilder: (context, index) {
                      var step = postData['steps'][index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              // Show step number
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: Text(
                                  '${index + 1}', // Show step number starting from 1
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: Text(step['description'])),
                            ],
                          ),
                          SizedBox(height: 10), // Adds 10px gap between steps
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  // Chức năng tương tác (Like, Comment)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: Color(0xff42423D),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.comment, color: Color(0xff42423D)),
                        onPressed: () {
                          // Điều hướng đến màn hình bình luận
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CommentScreen2(postId: postId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Danh sách bình luận
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('post_comments')
                            .where('postId', isEqualTo: postId)
                            .snapshots(),
                    builder: (context, commentSnapshot) {
                      if (commentSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (commentSnapshot.hasError) {
                        return Center(child: Text("Lỗi khi tải bình luận"));
                      }

                      var comments = commentSnapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          var comment = comments[index];
                          return ListTile(
                            title: Text(comment['user_name'] ?? "Anonymous"),
                            subtitle: Text(comment['content'] ?? "No comment"),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CommentScreen2 extends StatelessWidget {
  final String postId;

  CommentScreen2({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bình luận")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('post_comments')
                .where('postId', isEqualTo: postId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Lỗi khi tải bình luận"));
          }

          var comments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              var comment = comments[index];
              return ListTile(
                title: Text(comment['user_name'] ?? "Anonymous"),
                subtitle: Text(comment['content'] ?? "No comment"),
              );
            },
          );
        },
      ),
    );
  }
}
