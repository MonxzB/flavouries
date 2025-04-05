import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/ChefList/list_recipe_chef.dart';

class ChefProfileScreen1 extends StatefulWidget {
  final String name;
  final String imageUrl;

  const ChefProfileScreen1({
    Key? key,
    required this.name,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ChefProfileScreenState createState() => _ChefProfileScreenState();
}

class _ChefProfileScreenState extends State<ChefProfileScreen1> {
  late String userId; // Dùng để lưu user_id sau khi tìm thấy

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Gọi hàm để truy vấn user_id dựa trên name
  }

  Future<void> _loadUserId() async {
    try {
      // Truy vấn Firestore tìm kiếm userId dựa trên name
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('name', isEqualTo: widget.name) // Lọc theo trường 'name'
              .get();

      // Kiểm tra nếu có document phù hợp
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userId = snapshot.docs.first.id; // Lấy user_id từ document
        });
        print('Found user_id: $userId');
      } else {
        print('No user found with the name: ${widget.name}');
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chi tiết người dùng'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị thông tin người dùng
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff21330F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Master Chef',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff21330F),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Hiển thị thông tin người dùng từ Firestore (Sau khi load xong)
            Text(
              'Sở trường nấu ăn:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Các món ăn yêu thích (Chips)
            Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    label: Text('Kẹp Caramel'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Chip(
                    label: Text('Cà hồi'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Chip(
                    label: Text('Bánh su kem'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Chip(
                    label: Text('Panna cotta'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Chip(
                    label: Text('Tiramisu'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Chip(
                    label: Text('Bánh croissant'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Công thức yêu thích:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 👇 Thêm phần này để hiển thị công thức
            // Truyền userId vào danh sách công thức
            RecipeListViewChef(user_id: userId),
          ],
        ),
      ),
    );
  }
}
