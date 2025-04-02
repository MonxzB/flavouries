import 'package:flutter/material.dart';
import 'package:fluttertest/ui/Search/search_home.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo "Flavouries"
          Image.asset(
            'assets/images/logo.png', // Đảm bảo có logo trong thư mục assets
            height: 40,
            width: 160,
          ),

          // Icon Search
          IconButton(
            icon: Icon(Icons.search, color: Colors.black54, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
