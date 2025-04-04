import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/ui/Admin/AdminComment/admin_cmt.dart';
import 'package:fluttertest/ui/Admin/AdminFavourite/admin_favorite.dart';
import 'package:fluttertest/ui/Admin/AdminRecipe/admin_recipe.dart';
import 'package:fluttertest/ui/Admin/AdminUser/admin_user.dart';
import 'package:fluttertest/ui/Community/comm_create.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int usersCount = 0;
  int recipesCount = 0;
  int favouritesCount = 0;
  int commentsCount = 0;

  String userName = ''; // Store the user's name
  String userAvatarUrl = ''; // Store the user's avatar URL

  @override
  void initState() {
    super.initState();
    _getDataCount(); // Call the function to fetch data counts
    _getUserData();
  }

  // Fetch counts for users, recipes, and favourites
  Future<void> _getDataCount() async {
    try {
      // Get the number of documents in 'users' collection
      var usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      var recipesSnapshot =
          await FirebaseFirestore.instance.collection('recipes').get();
      var favouritesSnapshot =
          await FirebaseFirestore.instance.collection('favourites').get();
      var commentsSnapshot =
          await FirebaseFirestore.instance.collection('recipe_comments').get();

      setState(() {
        usersCount = usersSnapshot.size; // Total number of users
        recipesCount = recipesSnapshot.size; // Total number of recipes
        favouritesCount = favouritesSnapshot.size; // Total number of favourites
        commentsCount = commentsSnapshot.size; // Total number of comments
      });
    } catch (e) {
      print("Error fetching document counts: $e");
    }
  }

  // Fetch the user's name and avatar URL from Firestore
  Future<void> _getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Retrieve the user document from Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['name'] ?? 'Admin'; // Set the name
            userAvatarUrl = userDoc['avatar_url'] ?? ''; // Set the avatar URL
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Admin Info and Greeting
            Text(
              'Trang quản trị',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Stat Cards showing the counts
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjusted to 2 columns for better layout
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4, // Correct item count based on cardData length
              itemBuilder: (context, index) {
                // Define card data with count values
                List<Map<String, dynamic>> cardData = [
                  {
                    'icon': Icons.account_circle,
                    'title': '$usersCount',
                    'color': Colors.green.shade100,
                    'label': 'Người dùng',
                    'page':
                        AdminUser(), // Assign the corresponding page to navigate to
                  },
                  {
                    'icon': Icons.receipt,
                    'title': '$recipesCount',
                    'color': Colors.blue.shade100,
                    'label': 'Công thức',
                    'page': AdminRecipeScreen(), // Page for recipes (example)
                  },
                  {
                    'icon': Icons.favorite,
                    'title': '$favouritesCount',
                    'color': Colors.orange.shade100,
                    'label': 'Yêu thích',
                    'page':
                        AdminFavouritesScreen(), // Page for favourites (example)
                  },
                  {
                    'icon': Icons.comment,
                    'title': '$commentsCount',
                    'color': Colors.orange.shade100,
                    'label': 'Bình luận',
                    'page':
                        AdminCommentsScreen(), // Page for comments (example)
                  },
                ];

                return GestureDetector(
                  onTap: () {
                    // When a card is tapped, navigate to the corresponding page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                cardData[index]['page'], // Navigate to the assigned page
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 120, // Set the height to 120px
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: cardData[index]['color'],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(cardData[index]['icon'], color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          cardData[index]['title'],
                          style: TextStyle(color: Colors.green, fontSize: 18),
                        ),
                        Text(
                          cardData[index]['label'],
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 60),

            // Buttons
            ElevatedButton(
              onPressed: () {
                // Điều hướng sang CreatePostScreen khi nhấn nút
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostScreen()),
                );
              },
              child: Text(
                'Thêm mới công thức',
                style: TextStyle(
                  color: Colors.white, // Đặt màu chữ là màu trắng
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Colors.green),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 **AppBar**
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child:
            userAvatarUrl.isNotEmpty
                ? CircleAvatar(backgroundImage: NetworkImage(userAvatarUrl))
                : CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white),
                  backgroundColor: Colors.grey,
                ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Row(
          children: [
            SizedBox(width: 10),
            Text(
              'Chào $userName', // Hiển thị tên người dùng
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      centerTitle: true,
      actions: [Icon(Icons.notifications, color: Colors.black)],
    );
  }
}
