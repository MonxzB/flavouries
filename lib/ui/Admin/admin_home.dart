import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chào Admin1'),
        backgroundColor: Colors.green,
        actions: [Icon(Icons.notifications)],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text('Trang quản trị', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grid_on, color: Colors.white),
                            SizedBox(height: 8),
                            Text(
                              '30,22',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Thêm mới công thức'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Corrected parameter
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Thêm mới bài viết'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Corrected parameter
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('Thêm mới đầu bếp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Corrected parameter
              ),
            ),
          ],
        ),
      ),
    );
  }
}
