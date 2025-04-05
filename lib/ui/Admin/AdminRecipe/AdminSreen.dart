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

class EditRecipeScreen extends StatefulWidget {
  final String recipeId;

  EditRecipeScreen({required this.recipeId});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _kcalController;
  late TextEditingController _timeController;
  late TextEditingController _avatarUrlController;
  late TextEditingController _imageUrlController;

  // Các controller cho ingredients và steps
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _kcalController = TextEditingController();
    _timeController = TextEditingController();
    _avatarUrlController = TextEditingController();
    _imageUrlController = TextEditingController();

    _ingredientsController = TextEditingController();
    _stepsController = TextEditingController();

    _loadRecipeData();
  }

  Future<void> _loadRecipeData() async {
    try {
      DocumentSnapshot recipeSnapshot =
          await FirebaseFirestore.instance
              .collection('recipes')
              .doc(widget.recipeId)
              .get();

      if (recipeSnapshot.exists) {
        var recipeData = recipeSnapshot.data() as Map<String, dynamic>;

        _titleController.text = recipeData['title'] ?? '';
        _descriptionController.text = recipeData['description'] ?? '';
        _kcalController.text = recipeData['calories'] ?? '';
        _timeController.text = recipeData['calories'] ?? '';
        _avatarUrlController.text = recipeData['avatarUrl'] ?? '';
        _imageUrlController.text = recipeData['imageUrl'] ?? '';
        _ingredientsController.text = (recipeData['ingredients'] ?? []).join(
          ", ",
        );
        _stepsController.text = (recipeData['steps'] ?? []).join(", ");
      }
    } catch (e) {
      print("Error loading recipe data: $e");
    }
  }

  Future<void> _saveRecipe() async {
    try {
      Map<String, dynamic> updatedRecipeData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'ingredients':
            _ingredientsController.text
                .split(',')
                .map((e) => e.trim())
                .toList(),
        'steps': _stepsController.text.split(',').map((e) => e.trim()).toList(),
        'kcal': _kcalController.text,
        'time': _timeController.text,
        'avatarUrl': _avatarUrlController.text,
        'imageUrl': _imageUrlController.text,
      };

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .update(updatedRecipeData);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recipe updated thành công')));
      Navigator.pop(context); // Quay lại màn hình quản lý công thức
    } catch (e) {
      print("Error updating recipe: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating recipe')));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _kcalController.dispose();
    _timeController.dispose();
    _avatarUrlController.dispose();
    _imageUrlController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa công thức')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
              ),
              SizedBox(height: 10),

              // Description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
              ),
              SizedBox(height: 10),

              // Ingredients
              TextField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Thành phần'),
              ),
              SizedBox(height: 10),

              // Steps
              TextField(
                controller: _stepsController,
                decoration: InputDecoration(labelText: 'Cách làm'),
              ),
              SizedBox(height: 10),

              // Kcal
              TextField(
                controller: _kcalController,
                decoration: InputDecoration(labelText: 'Lượng calo'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              // Time
              TextField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Thời gian'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),

              // Avatar URL
              // TextField(
              //   controller: _avatarUrlController,
              //   decoration: InputDecoration(labelText: 'Avatar URL'),
              // ),
              // SizedBox(height: 10),

              // Image URL
              // TextField(
              //   controller: _imageUrlController,
              //   decoration: InputDecoration(labelText: 'Image URL'),
              // ),
              // SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF84CC16),
                    padding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 100,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
