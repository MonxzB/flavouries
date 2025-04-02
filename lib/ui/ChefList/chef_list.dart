import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertest/ui/ChefList/detail_chef.dart'; // Import nếu cần

class Chef {
  final String name;
  final String imageUrl;
  final String userId; // Thay 'chefId' bằng 'userId'

  Chef({required this.name, required this.imageUrl, required this.userId});
}

class ChefList extends StatefulWidget {
  @override
  _ChefListState createState() => _ChefListState();
}

class _ChefListState extends State<ChefList> {
  List<Chef> chefs = [];

  // Hàm lấy dữ liệu từ Firestore
  Future<void> _fetchUsers() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('users').get();

      final fetchedChefs =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return Chef(
              name: data['name'] ?? 'Unknown User',
              imageUrl:
                  data['avatar_url'] ??
                  'https://firebasestorage.googleapis.com/v0/b/your-project-id.appspot.com/o/default_chef_image.jpg?alt=media', // Đảm bảo có URL mặc định
              userId: doc.id, // Thêm userId vào mỗi user từ doc.id
            );
          }).toList();

      setState(() {
        chefs = fetchedChefs;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Lấy dữ liệu khi màn hình được khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shrinkWrap: true, // ✅ Tránh lỗi overflow
      physics:
          const NeverScrollableScrollPhysics(), // ✅ Vô hiệu hóa cuộn riêng của GridView
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // ✅ 5 cột trên mỗi hàng
        crossAxisSpacing: 10, // ✅ Khoảng cách ngang
        mainAxisSpacing: 15, // ✅ Khoảng cách dọc
        childAspectRatio: 0.7, // ✅ Điều chỉnh tỷ lệ phù hợp
      ),
      itemCount: chefs.length,
      itemBuilder: (context, index) => _buildChefCard(context, chefs[index]),
    );
  }

  Widget _buildChefCard(BuildContext context, Chef chef) {
    return GestureDetector(
      onTap: () {
        // Chuyển sang màn ChefProfileScreen với thông tin người dùng
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChefProfileScreen(
                  name: chef.name,
                  imageUrl: chef.imageUrl,
                  userId: chef.userId, // Truyền userId vào ChefProfileScreen
                ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ảnh
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
            ),
            child: ClipOval(
              child: Image.network(
                chef.imageUrl, // Dùng avatar_url từ Firestore
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    size: 40,
                  ); // Hiển thị icon nếu có lỗi
                },
              ),
            ),
          ),
          const SizedBox(height: 5), // Khoảng cách giữa ảnh và text
          // Text
          SizedBox(
            width: 60,
            child: Text(
              chef.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Color(0xFF21330F),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
