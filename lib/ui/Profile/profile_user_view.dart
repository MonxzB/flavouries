import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/ui/CardMostSearch/recipe_card.dart';
import 'package:fluttertest/ui/Profile/profile_edit.dart'; // Đảm bảo rằng bạn đã có widget RecipeCard

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> favoriteRecipes = [];
  bool isLoadingRecipes = true;
  bool isLoadingFavorites = true;

  late String userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Lấy userId từ FirebaseAuth (nếu người dùng đã đăng nhập)
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Gọi hàm lấy dữ liệu
    _fetchRecipes();
    _fetchFavoriteRecipes();
  }

  // Lấy tất cả công thức của người dùng
  Future<void> _fetchRecipes() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('recipes')
              .where('user_id', isEqualTo: userId)
              .get();

      final fetched =
          snapshot.docs.map((doc) {
            final data = doc.data();

            return {
              "imageUrl": data["image_url"] ?? '',
              "title": data["title"] ?? '',
              "description": data["description"] ?? '',
              "ingredients":
                  (data["ingredients"] as List?)
                      ?.map((e) => Map<String, String>.from(e))
                      .toList() ??
                  [],
              "steps":
                  (data["steps"] as List?)
                      ?.map((e) => Map<String, dynamic>.from(e))
                      .toList() ??
                  [],
              "kcal": data["calories"]?.toString() ?? "0 Kcal",
              "time": "${(data["steps"] as List?)?.length ?? 0} Min",
              "chefName": data["name"] ?? 'Unknown Chef', // Lấy tên người dùng
              "chefImage":
                  data["avatar_url"] ??
                  'https://i.pravatar.cc/150?u=${userId}', // Lấy hình ảnh người dùng
              "likes": "0",
              "isLiked": false,
              "id": doc.id,
            };
          }).toList();

      setState(() {
        recipes = fetched;
        isLoadingRecipes = false;
      });
    } catch (e) {
      print("Error fetching recipes: $e");
      setState(() => isLoadingRecipes = false);
    }
  }

  // Lấy các công thức yêu thích của người dùng
  Future<void> _fetchFavoriteRecipes() async {
    try {
      final favSnapshot =
          await FirebaseFirestore.instance
              .collection('favourites')
              .where('user_id', isEqualTo: userId)
              .get();

      final recipeIds =
          favSnapshot.docs.map((doc) => doc['recipe_id'].toString()).toList();

      if (recipeIds.isEmpty) {
        setState(() {
          favoriteRecipes = [];
          isLoadingFavorites = false;
        });
        return;
      }

      final recipeSnap =
          await FirebaseFirestore.instance
              .collection('recipes')
              .where(FieldPath.documentId, whereIn: recipeIds)
              .get();

      final fetched =
          recipeSnap.docs.map((doc) {
            final data = doc.data();

            return {
              "imageUrl": data["image_url"] ?? '',
              "title": data["title"] ?? '',
              "description": data["description"] ?? '',
              "ingredients":
                  (data["ingredients"] as List?)
                      ?.map((e) => Map<String, String>.from(e))
                      .toList() ??
                  [],
              "steps":
                  (data["steps"] as List?)
                      ?.map((e) => Map<String, dynamic>.from(e))
                      .toList() ??
                  [],
              "kcal": data["calories"]?.toString() ?? "0 Kcal",
              "time": "${(data["steps"] as List?)?.length ?? 0} Min",
              "chefName": data["name"] ?? 'Unknown Chef', // Lấy tên người dùng
              "chefImage":
                  data["avatar_url"] ??
                  'https://i.pravatar.cc/150?u=${userId}', // Lấy hình ảnh người dùng
              "likes": "0",
              "isLiked": true,
              "id": doc.id,
            };
          }).toList();

      setState(() {
        favoriteRecipes = fetched;
        isLoadingFavorites = false;
      });
    } catch (e) {
      print("Error fetching favorite recipes: $e");
      setState(() => isLoadingFavorites = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Cá nhân",
          style: TextStyle(
            color: Color(0xff21330F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: NestedScrollView(
        headerSliverBuilder:
            (context, _) => [SliverToBoxAdapter(child: _buildProfileHeader())],
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Color(0xff21330F),
              indicatorColor: Colors.green,
              tabs: [Tab(text: "Công thức"), Tab(text: "Yêu thích")],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecipeGrid(recipes, isLoadingRecipes),
                  _buildRecipeGrid(favoriteRecipes, isLoadingFavorites),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hiển thị các công thức trong Grid
  Widget _buildRecipeGrid(List<Map<String, dynamic>> list, bool isLoading) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (list.isEmpty) {
      return Center(child: Text("Không có công thức nào."));
    }
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final recipe = list[index];
        return RecipeCard(
          imageUrl: recipe["imageUrl"],
          title: recipe["title"],
          description: recipe["description"],
          ingredients: recipe["ingredients"],
          steps: recipe["steps"],
          kcal: recipe["kcal"],
          time: recipe["time"],
          name: recipe["chefName"], // Dùng tên người dùng
          avatarUrl: recipe["chefImage"], // Dùng ảnh của người dùng
          likes: recipe["likes"],
          isLiked: recipe["isLiked"],
          recipeId: recipe["id"] ?? '',
        );
      },
    );
  }

  // Hiển thị thông tin người dùng
  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
          SizedBox(height: 10),
          Text(
            "Nguyễn Văn X",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "0 Follow • 12345 Follower • 1027 Lượt thích",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingProfileScreen()),
              );
            },
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              "Chỉnh sửa trang cá nhân",
              style: TextStyle(color: Colors.green),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Tôi ghét ăn tối bằng thức ăn đóng hộp",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children:
                  [
                    "Kẹo Caramel",
                    "Bánh su kem",
                    "Panna cotta",
                  ].map((tag) => _buildTag(tag)).toList(),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  // Tạo các tag cho sở thích
  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: Colors.green)),
    );
  }
}
