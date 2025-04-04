import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRecipeScreen extends StatefulWidget {
  @override
  _AdminRecipeScreenState createState() => _AdminRecipeScreenState();
}

class _AdminRecipeScreenState extends State<AdminRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý công thức')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Recipes Found'));
          }

          final recipes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipeData = recipes[index].data() as Map<String, dynamic>;
              final recipeId = recipes[index].id;
              return AdminRecipeCard(
                recipeData: recipeData,
                recipeId: recipeId,
                onDelete: () => _deleteRecipe(recipeId),
                onEdit: () => _editRecipe(recipeId),
              );
            },
          );
        },
      ),
    );
  }

  // Hàm xóa công thức
  Future<void> _deleteRecipe(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recipe Deleted Successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: Unable to delete recipe')));
    }
  }

  // Hàm chỉnh sửa công thức
  void _editRecipe(String recipeId) {
    // Điều hướng đến màn hình chỉnh sửa công thức, bạn có thể xây dựng màn hình này
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipeScreen(recipeId: recipeId),
      ),
    );
  }
}

// Widget để hiển thị mỗi công thức
class AdminRecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipeData;
  final String recipeId;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  AdminRecipeCard({
    required this.recipeData,
    required this.recipeId,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh công thức
            recipeData['image_url'] != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    recipeData['image_url'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                )
                : SizedBox(width: 100, height: 100),

            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên công thức
                  Text(
                    recipeData['title'] ?? 'No Title',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  // Mô tả
                  Text(
                    recipeData['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            // Thêm menu hoặc nút xóa/chỉnh sửa
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Hiển thị dialog xác nhận xóa
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirm Delete'),
                      content: Text(
                        'Are you sure you want to delete this recipe?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete();
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Màn hình chỉnh sửa công thức (sử dụng sample, bạn có thể thêm form để sửa)
class EditRecipeScreen extends StatelessWidget {
  final String recipeId;

  EditRecipeScreen({required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Recipe')),
      body: Center(child: Text('Edit screen for recipe $recipeId')),
    );
  }
}
