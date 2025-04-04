import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/Screens/home_screen.dart';
import 'package:fluttertest/components/post_options_popup.dart';
import 'package:fluttertest/components/share.dart';
import 'package:fluttertest/ui/Community/comm_create.dart';
import 'package:fluttertest/ui/Community/post_detail.dart';
import 'package:fluttertest/ui/Community/comm_cmt.dart';
import 'package:fluttertest/components/navbar.dart';
import 'package:fluttertest/ui/Profile/profile_user_view.dart';
import 'package:fluttertest/ui/Search/search_home.dart'; // Đảm bảo import CustomNavBar

class FlavouriesScreen extends StatefulWidget {
  @override
  _FlavouriesScreenState createState() => _FlavouriesScreenState();
}

class _FlavouriesScreenState extends State<FlavouriesScreen> {
  String? userAvatar; // Nullable biến

  @override
  void initState() {
    super.initState();
    // Lấy thông tin người dùng từ Firestore khi màn hình được tạo
    _getUserData();
  }

  // Lấy thông tin người dùng từ Firestore
  Future<void> _getUserData() async {
    try {
      String userId =
          "user_id"; // Bạn có thể thay bằng FirebaseAuth.instance.currentUser?.uid
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userSnapshot.exists) {
        setState(() {
          userAvatar =
              userSnapshot['avatar_url'] ??
              "https://firebasestorage.googleapis.com/v0/b/flavouries-b202d.firebasestorage.app/o/posts%2F1741919637126.jpg?alt=media&token=c188ccd6-c1f7-4870-ba20-f6bac10c271b"; // Default avatar nếu không có
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

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
                userAvatar != null
                    ? CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          userAvatar != null ? NetworkImage(userAvatar!) : null,
                      backgroundColor: Colors.grey.shade300,
                    )
                    : CircleAvatar(
                      radius: 20,
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
                      .collection('recipes')
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
    String recipeId =
        postData['recipe_id'] ?? 'Unknown Recipe ID'; // Default nếu không có

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('users')
              .doc(postData["user_id"])
              .get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
        String userName = userData['name'] ?? "User";
        String userAvatar =
            userData['avatar_url'] ??
            "https://firebasestorage.googleapis.com/v0/b/flavouries-b202d.firebasestorage.app/o/posts%2F1741919637126.jpg?alt=media&token=c188ccd6-c1f7-4870-ba20-f6bac10c271b"; // Default avatar if no avatar

        return GestureDetector(
          onTap: () {
            // Chuyển sang màn chi tiết của bài viết khi nhấn vào card
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDetailScreen(postId: post.id),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Colors.white, // Màu nền là trắng
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(userAvatar),
                        backgroundColor: Colors.grey.shade300,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  postData["title"] ?? "No Title",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  onPressed: () {
                                    PostOptionsPopup.show(context);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              postData["description"] ?? "No Description",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Image.network(
                    postData["image_url"] ?? '',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder<int>(
                  future: FirebaseFirestore.instance
                      .collection('post_comments')
                      .where('postId', isEqualTo: post.id)
                      .get()
                      .then((querySnapshot) => querySnapshot.size),
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    int commentCount = commentSnapshot.data ?? 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              postData['isLiked'] == true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  postData['isLiked'] == true
                                      ? Colors.red
                                      : Colors.black,
                            ),
                            onPressed:
                                () => _toggleLike(post.id, postData['isLiked']),
                          ),
                          SizedBox(width: 4),
                          IconButton(
                            icon: Icon(Icons.comment_bank_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CommentScreen(postData: postData),
                                ),
                              );
                            },
                          ),
                          Text(
                            commentCount.toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 4),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              showSharePopup(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleLike(String recipeId, bool? isLiked) async {
    await FirebaseFirestore.instance.collection('recipes').doc(recipeId).update(
      {'isLiked': !(isLiked ?? false)},
    );
  }
}
