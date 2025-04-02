import 'package:flutter/material.dart';

class CookingSkillScreen extends StatefulWidget {
  @override
  _CookingSkillScreenState createState() => _CookingSkillScreenState();
}

class _CookingSkillScreenState extends State<CookingSkillScreen> {
  List<String> skillLevels = [
    "Bắt đầu",
    "Cơ bản",
    "Trung bình",
    "Có kinh nghiệm",
    "Chuyên nghiệp"
  ];

  String? selectedSkill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiến trình (3/3)
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Color(0xffBABCB5)),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Color(0xffBABCB5)),
                SizedBox(width: 5),
                Icon(Icons.circle, size: 10, color: Colors.black),
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
              "Khả năng nấu ăn của bạn",
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
            Column(
              children: skillLevels.map((skill) {
                bool isSelected = skill == selectedSkill;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSkill = skill;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xFF84CC16)
                                  : Colors.grey.shade500,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Icon(Icons.check,
                                  size: 18, color: Color(0xFF84CC16))
                              : null,
                        ),
                        SizedBox(width: 10),
                        Text(
                          skill,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                isSelected ? Color(0xFF84CC16) : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
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
                          style: TextStyle(fontSize: 16, color: Colors.black)),
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
                        backgroundColor: Color(0xFF84CC16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text("Hoàn thành",
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
