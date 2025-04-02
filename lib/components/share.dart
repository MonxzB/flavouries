import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void showSharePopup(BuildContext context) {
  // 👈 Đảm bảo có tham số context
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext ctx) => ShareBottomSheet(),
  );
}

class ShareBottomSheet extends StatelessWidget {
  final List<Map<String, String>> sharePlatforms = [
    {"name": "Zalo", "icon": "assets/icons/zalo.png"},
    {"name": "Instagram", "icon": "assets/icons/instagram.png"},
    {"name": "Facebook", "icon": "assets/icons/facebook.png"},
    {"name": "Messenger", "icon": "assets/icons/messenger.png"},
    {"name": "SMS", "icon": "assets/icons/sms.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chia sẻ lên",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                sharePlatforms.map((platform) {
                  return GestureDetector(
                    onTap: () {
                      Share.share(
                        'Xem video hướng dẫn nấu ăn tại đây: https://example.com/video',
                      );
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 28,
                          child: Image.asset(platform["icon"]!, width: 40),
                        ),
                        SizedBox(height: 6),
                        Text(platform["name"]!, style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
