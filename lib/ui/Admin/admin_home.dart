import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int usersCount = 0;
  int recipesCount = 0;
  int favouritesCount = 0;

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

      setState(() {
        usersCount = usersSnapshot.size; // Total number of users
        recipesCount = recipesSnapshot.size; // Total number of recipes
        favouritesCount = favouritesSnapshot.size; // Total number of favourites
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
                .collection(
                  'users',
                ) // Assuming you store user data in 'users' collection
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
          ), // Add padding to the left of leading
          child:
              userAvatarUrl.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(userAvatarUrl))
                  : CircleAvatar(
                    child: Icon(Icons.person, color: Colors.white),
                    backgroundColor: Colors.grey,
                  ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
          ), // Add padding to the right of title
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
      ),
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
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 3, // Total 3 cards
              itemBuilder: (context, index) {
                // Define card data with count values
                List<Map<String, dynamic>> cardData = [
                  {
                    'icon': Icons.account_circle,
                    'title': '$usersCount',
                    'color': Colors.green.shade100,
                    'label': 'Người dùng',
                  },
                  {
                    'icon': Icons.receipt,
                    'title': '$recipesCount',
                    'color': Colors.blue.shade100,
                    'label': 'Công thức',
                  },
                  {
                    'icon': Icons.favorite,
                    'title': '$favouritesCount',
                    'color': Colors.orange.shade100,
                    'label': 'Yêu thích',
                  },
                ];

                return Container(
                  alignment: Alignment.center,
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
                );
              },
            ),

            SizedBox(height: 100),

            // Buttons
            ElevatedButton(
              onPressed: () {},
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Thêm mới bài viết',
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
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Thêm mới đầu bếp',
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
}
