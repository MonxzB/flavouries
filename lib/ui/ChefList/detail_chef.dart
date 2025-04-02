import 'package:flutter/material.dart';
import 'package:fluttertest/ui/ChefList/list_recipe_chef.dart'; // Import nếu cần

class ChefProfileScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String userId; // Thay từ chefId thành userId

  const ChefProfileScreen({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.userId, // Đảm bảo truyền userId vào
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chi tiết người dùng'), // Cập nhật tên màn hình
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Info
            Column(
              children: [
                // Ảnh
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150, // Đặt chiều rộng ảnh
                      height: 150, // Đặt chiều cao ảnh
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16), // Khoảng cách giữa ảnh và text
                // Thông tin người dùng (Tên, Danh hiệu, Nút)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff21330F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Master Chef', // Giữ lại danh hiệu, nếu cần thay đổi có thể chỉnh sửa
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff21330F),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () {}, // Để trống hoặc thêm chức năng theo nhu cầu
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Color(0xFF446E26),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Theo dõi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff446E26),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'Tôi ghét ăn tối bằng thức ăn đóng hộp',
                style: TextStyle(fontSize: 16, color: Color(0xff21330F)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sở trường nấu ăn:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
            RecipeListViewChef(userId: userId), // Truyền đúng userId
          ],
        ),
      ),
    );
  }
}
