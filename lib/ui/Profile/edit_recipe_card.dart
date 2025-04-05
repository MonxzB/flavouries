import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore

class EditRecipeCard extends StatefulWidget {
  final String recipeId;
  final String title;
  final String description;
  final List<Map<String, String>> ingredients;
  final List<Map<String, dynamic>> steps;
  final String imageUrl;
  final String kcal;
  final String time;
  final String avatarUrl;

  const EditRecipeCard({
    Key? key,
    required this.recipeId,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.kcal,
    required this.time,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  _EditRecipeCardState createState() => _EditRecipeCardState();
}

class _EditRecipeCardState extends State<EditRecipeCard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _kcalController;
  late TextEditingController _timeController;

  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _kcalController = TextEditingController(text: widget.kcal);
    _timeController = TextEditingController(text: widget.time);

    // Initialize the controllers for ingredients and steps as a comma-separated string
    _ingredientsController = TextEditingController(
      text: widget.ingredients
          .map((ingredient) => ingredient["name"] ?? "")
          .join(", "),
    );
    _stepsController = TextEditingController(
      text: widget.steps.map((step) => step["description"] ?? "").join(", "),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _kcalController.dispose();
    _timeController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  // Save updated recipe
  void _saveRecipe() async {
    try {
      Map<String, dynamic> updatedRecipeData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'ingredients':
            _ingredientsController.text
                .split(',')
                .map((e) => {'name': e.trim()})
                .toList(),
        'steps':
            _stepsController.text
                .split(',')
                .map((e) => {'description': e.trim()})
                .toList(),
        'kcal': _kcalController.text,
        'time': _timeController.text,
      };

      // Update the recipe in Firebase
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .update(updatedRecipeData);

      print("Công thức đã được lưu: ${_titleController.text}");

      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      print("Lỗi khi lưu công thức: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF84CC16),
        title: Text(
          'Sửa Công Thức',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Chỉnh sửa Công Thức',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF21330F),
              ),
            ),
            SizedBox(height: 10),

            // Recipe Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Title TextField
            _buildTextField(_titleController, 'Tiêu đề công thức'),

            SizedBox(height: 10),

            // Description TextField
            _buildTextField(_descriptionController, 'Mô tả công thức'),

            SizedBox(height: 10),

            // Ingredients
            _buildIngredientsField(),

            SizedBox(height: 10),

            // Steps
            _buildStepsField(),

            SizedBox(height: 10),

            // Kcal TextField
            _buildTextField(_kcalController, 'Calories'),

            SizedBox(height: 10),

            // Time TextField
            _buildTextField(_timeController, 'Thời gian chế biến'),

            SizedBox(height: 20),

            // Save Button
            Center(
              // Wrap the button with Center to align it in the center
              child: ElevatedButton(
                onPressed: _saveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF84CC16),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Lưu công thức',
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
    );
  }

  // Widget for text fields
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16, color: Color(0xFF21330F)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: TextStyle(fontSize: 14, color: Colors.black),
    );
  }

  // Widget for ingredients
  Widget _buildIngredientsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nguyên liệu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF21330F),
          ),
        ),
        SizedBox(height: 6),
        Column(
          children:
              widget.ingredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            '${ingredient["name"]} - ${ingredient["quantity"]}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  // Widget for steps
  Widget _buildStepsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Các bước thực hiện',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF21330F),
          ),
        ),
        SizedBox(height: 6),
        Column(
          children:
              widget.steps.map((step) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${step["description"]}',
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
