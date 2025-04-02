import 'package:flutter/material.dart';

class PostOptionsPopup {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupItem(context, "Chi tiết bài viết", () {
                Navigator.pop(context);
                print("Chi tiết bài viết");
              }),
              _buildPopupItem(context, "Lưu bài viết", () {
                Navigator.pop(context);
                print("Lưu bài viết");
              }),
              _buildPopupItem(context, "Thêm vào mục yêu thích", () {
                Navigator.pop(context);
                print("Thêm vào mục yêu thích");
              }),
              _buildPopupItem(context, "Sao chép liên kết", () {
                Navigator.pop(context);
                print("Sao chép liên kết");
              }),
              Divider(),
              _buildPopupItem(context, "Hủy", () {
                Navigator.pop(context);
              }, isCancel: true),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildPopupItem(
    BuildContext context,
    String title,
    VoidCallback onTap, {
    bool isCancel = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center, // ✅ Căn giữa chữ
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isCancel ? Colors.red : Colors.black,
          ),
        ),
      ),
    );
  }
}
