import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/CardMostSearch/list_card.dart';
import 'package:fluttertest/ui/Search/list_search.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  // Define categories for search filtering
  final List<String> categories = [
    "Món cuốn",
    "Món nộm",
    "Món kho",
    "Món nước",
    "Món xào",
  ];

  List<String> searchHistory = [];
  List<Map<String, dynamic>> searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSearchResults);
    _fetchRecipes(); // Gọi hàm để lấy dữ liệu ngay khi khởi động
  }

  // Fetch dữ liệu từ Firestore
  Future<void> _fetchRecipes() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('recipes').get();
      final fetched =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            final ingredients =
                (data['ingredients'] as List?)
                    ?.map((e) => Map<String, String>.from(e))
                    .toList() ??
                [];

            final steps =
                (data['steps'] as List?)
                    ?.map((e) => Map<String, dynamic>.from(e))
                    .toList() ??
                [];

            return {
              'id': doc.id,
              'imageUrl': data['image_url'] ?? '',
              'title': data['title'] ?? '',
              'description': data['description'] ?? '',
              'ingredients': ingredients,
              'steps': steps,
              'kcal': data['calories']?.toString() ?? '0',
              'time': '${steps.length} mins',
              'chefImage': 'https://i.pravatar.cc/100?u=${data['chef_id']}',
              'chefName': 'Chef ${data['chef_id'] ?? 'Unknown'}',
              'isLiked': false,
              'likes': 0,
            };
          }).toList();

      setState(() {
        searchResults = fetched; // Lưu kết quả vào searchResults
      });
    } catch (e) {
      print("❌ Error loading recipes: $e");
    }
  }

  // Lọc kết quả tìm kiếm chỉ theo tiêu đề
  void _filterSearchResults() {
    String query = _searchController.text.toLowerCase().trim();

    setState(() {
      // Lọc danh sách món ăn theo tiêu đề
      searchResults =
          searchResults.where((recipe) {
            final titleMatch = recipe["title"].toLowerCase().contains(
              query,
            ); // So sánh không phân biệt chữ hoa chữ thường
            return titleMatch;
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () =>
              FocusScope.of(context).unfocus(), // Ẩn bàn phím khi nhấn ra ngoài
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔎 Thanh tìm kiếm
              Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xff585951), width: 2),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm công thức...",
                    border: InputBorder.none,
                    isDense: true,
                    prefixIcon: Icon(Icons.search, color: Color(0xFF21330F)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // 🔄 Hiển thị danh mục món ăn
              Center(
                child: SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = categories[index];
                          _filterSearchResults();
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Hiển thị kết quả tìm kiếm hoặc lịch sử tìm kiếm
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (widget, animation) =>
                          FadeTransition(opacity: animation, child: widget),
                  child:
                      _searchController.text.isEmpty
                          ? _buildSearchHistory() // Hiển thị lịch sử tìm kiếm
                          : searchResults.isNotEmpty
                          ? RecipeListSearch(
                            recipes: searchResults,
                          ) // Hiển thị kết quả tìm kiếm
                          : _buildNoResultWidget(), // Nếu không có kết quả
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Hiển thị lịch sử tìm kiếm
  Widget _buildSearchHistory() {
    return searchHistory.isNotEmpty
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lịch sử tìm kiếm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              children:
                  searchHistory.map((item) {
                    return ListTile(
                      title: Text(item),
                      trailing: Icon(Icons.history, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _searchController.text = item;
                        });
                      },
                    );
                  }).toList(),
            ),
          ],
        )
        : Container();
  }

  // 📌 Hiển thị khi không tìm thấy kết quả
  Widget _buildNoResultWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Không tìm thấy kết quả",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
