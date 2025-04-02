import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/components/post_options_popup.dart';
import 'package:fluttertest/components/share.dart';
import 'package:fluttertest/ui/Community/comm_cmt.dart';
import 'package:fluttertest/ui/Community/comm_create.dart'; // Import CommentScreen

class FlavouriesScreen extends StatefulWidget {
  @override
  _FlavouriesScreenState createState() => _FlavouriesScreenState();
}

class _FlavouriesScreenState extends State<FlavouriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Flavouries Community")),
      body: Column(
        children: [
          // Post entry section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to post creation screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePostScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFF355321),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        "Bạn muốn chia sẻ?",
                        style: TextStyle(color: Color(0xff9FA196)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fetch and display posts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('community_posts')
                      .orderBy('created_at', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi khi tải bài viết"));
                }

                var posts = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    return _buildPostItem(post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget to display each post
  Widget _buildPostItem(DocumentSnapshot post) {
    Map<String, dynamic> postData = post.data() as Map<String, dynamic>;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and description (with user image)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // User's Avatar Image
                CircleAvatar(
                  radius: 20, // Adjust the size as needed
                  backgroundImage: NetworkImage(
                    postData["user_avatar"] ?? '',
                  ), // Assuming user_avatar is a URL
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(width: 10), // Spacing between avatar and text
                // Title and Description in the same row
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                            postData["title"] ?? "No Title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis, // Handles long titles
                          ),
                          // More icon button
                          IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {
                              // Show the Post Options Popup when the three dots are clicked
                              PostOptionsPopup.show(
                                context,
                              ); // Show the post options popup
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 2),

                      // Description
                      Text(
                        postData["description"] ?? "No Description",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis, // Handles long descriptions
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Image
          Center(
            child: Image.network(
              postData["media_url"] ?? '',
              width: 335,
              height: 300,
              fit: BoxFit.cover, // Giữ tỷ lệ ảnh mà không bị bóp méo
            ),
          ),

          SizedBox(height: 10),

          // Like, Comment, and Share functionality with counts
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                // Like Icon with count
                IconButton(
                  icon: Icon(
                    postData['isLiked'] == true
                        ? Icons.favorite
                        : Icons.favorite_border, // Kiểm tra if isLiked là true
                    color:
                        postData['isLiked'] == true
                            ? Colors.red
                            : Colors.black, // Màu sắc khi thích hay chưa thích
                  ),
                  onPressed: () => _toggleLike(post.id, postData['isLiked']),
                ),
                // Like count
                Text(
                  postData['likes_count']?.toString() ?? '0',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(width: 4),
                // Comment Icon with count
                IconButton(
                  icon: Icon(Icons.comment_bank_outlined),
                  onPressed: () {
                    // Navigate to comment screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CommentScreen(
                              postData: postData,
                            ), // Pass postData to comment screen
                      ),
                    );
                  },
                ),
                // Comment count
                Text(
                  postData['comments_count']?.toString() ?? '0',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(width: 4),

                // Share Icon with count
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    showSharePopup(context);
                  },
                ),
                // Share count
                Text(
                  postData['shares_count']?.toString() ?? '0',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Toggle like functionality
  void _toggleLike(String postId, bool? isLiked) async {
    await FirebaseFirestore.instance
        .collection('community_posts')
        .doc(postId)
        .update({'isLiked': !(isLiked ?? false)});
  }
}
