import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminFavouritesScreen extends StatefulWidget {
  @override
  _AdminFavouritesScreenState createState() => _AdminFavouritesScreenState();
}

class _AdminFavouritesScreenState extends State<AdminFavouritesScreen> {
  List<Map<String, dynamic>> favourites = [];

  @override
  void initState() {
    super.initState();
    _fetchFavourites();
  }

  // Lấy danh sách yêu thích từ Firebase
  Future<void> _fetchFavourites() async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('favourites').get();

      List<Map<String, dynamic>> favouriteList = [];
      for (var doc in snapshot.docs) {
        var recipeId = doc['recipe_id'];
        var recipeSnapshot =
            await FirebaseFirestore.instance
                .collection('recipes')
                .doc(recipeId.toString()) // Ensure it's treated as a string
                .get();

        if (recipeSnapshot.exists) {
          favouriteList.add({
            'recipeId': recipeId,
            'image_url': recipeSnapshot['image_url'] ?? '',
            'title': recipeSnapshot['title'] ?? '',
            'description': recipeSnapshot['description'] ?? '',
          });
        }
      }

      setState(() {
        favourites = favouriteList;
      });
    } catch (e) {
      print("Error fetching favourites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Công thức yêu thích',
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
            favourites.isEmpty
                ? Center(
                  child: CircularProgressIndicator(),
                ) // Loading nếu chưa lấy được dữ liệu
                : ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final fav = favourites[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading:
                            fav['image_url'] != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    fav['image_url'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : SizedBox(),
                        title: Text(fav['title']),
                        subtitle: Text(fav['description'] ?? 'No Description'),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
