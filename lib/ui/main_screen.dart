import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/home_screen.dart';
import 'package:fluttertest/components/navbar.dart';
import 'package:fluttertest/ui/Community/comm_home.dart';
import 'package:fluttertest/ui/Profile/profile_user_view.dart';
import 'package:fluttertest/ui/Search/search_home.dart'; // Import thanh navbar của bạn

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Mặc định chọn tab đầu tiên

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    FlavouriesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _screens[_selectedIndex], // Hiển thị màn hình tương ứng với _selectedIndex
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Cập nhật index khi người dùng chọn tab
          });
        },
      ),
    );
  }
}
