import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent, // Nền trong suốt
      color: Color(0xFFFEFEFE), // Màu nền navbar
      buttonBackgroundColor: Color(0xFF84CC16), // Màu nền khi chọn
      height: 68,
      animationDuration: Duration(milliseconds: 300),
      items: [
        _buildNavItem(Icons.restaurant_menu, 0),
        _buildNavItem(Icons.search, 1),
        _buildNavItem(Icons.explore, 2),
        _buildNavItem(Icons.person, 3),
      ],
      index: selectedIndex,
      onTap: onTap,
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      decoration:
          isSelected
              ? BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF84CC16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3384CC16), // Bóng đổ nhẹ
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              )
              : BoxDecoration(), // Không có hiệu ứng khi chưa chọn
      padding: EdgeInsets.all(isSelected ? 6 : 0),
      child: Icon(
        icon,
        size: 24,
        color: isSelected ? Color(0xFFF6F6F6) : Color(0xFF9FA196),
      ),
    );
  }
}
