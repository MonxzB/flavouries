import 'package:flutter/material.dart';

class RestrictionSelectionScreen extends StatefulWidget {
  @override
  _RestrictionSelectionScreenState createState() =>
      _RestrictionSelectionScreenState();
}

class _RestrictionSelectionScreenState
    extends State<RestrictionSelectionScreen> {
  List<String> restrictionOptions = [
    "Tôm",
    "Cá hồi",
    "Thịt gà",
    "Tim",
    "Rau xanh",
    "Thịt chó",
    "Rau cần",
    "Ớt chuông",
    "Hành tây",
    "Hành lá"
  ];

  List<String> selectedRestrictions = [];

  void _toggleSelection(String item) {
    setState(() {
      if (selectedRestrictions.contains(item)) {
        selectedRestrictions.remove(item);
      } else {
        selectedRestrictions.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiến trình (2/3)
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Color(0xffBABCB5)),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.black),
                SizedBox(width: 5),
                Icon(Icons.circle_outlined, size: 10, color: Color(0xffBABCB5)),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text("Bỏ qua",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                )
              ],
            ),
            SizedBox(height: 20),

            // Tiêu đề
            Text(
              "Những thành phần bạn muốn hạn chế?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            SizedBox(height: 8),

            // Mô tả
            Text(
              "Điều này sẽ giúp tìm ra những công thức phù hợp nhất với bạn.",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            SizedBox(height: 20),

            // Danh sách lựa chọn
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: restrictionOptions.map((item) {
                bool isSelected = selectedRestrictions.contains(item);
                return GestureDetector(
                  onTap: () => _toggleSelection(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF84CC16) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xFF84CC16)
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacer(),

            // Nút điều hướng
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text("Trước đó",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xffBABCB5))),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text("Tiếp tục",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
