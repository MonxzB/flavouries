import 'package:flutter/material.dart';

class DietSelectionScreen extends StatefulWidget {
  @override
  _DietSelectionScreenState createState() => _DietSelectionScreenState();
}

class _DietSelectionScreenState extends State<DietSelectionScreen> {
  List<String> dietOptions = [
    "Không",
    "Ăn chay",
    "Ăn không gluten",
    "Ăn keto",
    "Ăn ít carbohydrate",
    "Ăn Paleo",
    "Ăn kiêng DASH",
    "Thuần chay",
    "Ăn nhạt",
    "Ăn low-fat",
    "Ăn bán chay",
    "Chỉ ăn thịt"
  ];

  List<String> selectedDiets = ["Không"]; // Mặc định chọn "Không"

  void _toggleSelection(String diet) {
    setState(() {
      if (diet == "Không") {
        selectedDiets.clear();
        selectedDiets.add("Không");
      } else {
        if (selectedDiets.contains("Không")) {
          selectedDiets.remove("Không");
        }
        if (selectedDiets.contains(diet)) {
          selectedDiets.remove(diet);
        } else {
          selectedDiets.add(diet);
        }
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
            // Tiến trình (1/3)
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colors.black),
                SizedBox(width: 5),
                Icon(Icons.circle_outlined, size: 10, color: Color(0xffBABCB5)),
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
              "Bạn có chế độ ăn uống như thế nào?",
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
              children: dietOptions.map((diet) {
                bool isSelected = selectedDiets.contains(diet);
                return GestureDetector(
                  onTap: () => _toggleSelection(diet),
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
                      diet,
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

            // Nút tiếp tục
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF84CC16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text("Tiếp tục",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
