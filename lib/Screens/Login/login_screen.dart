import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // To access Firestore
import 'package:fluttertest/Screens/home_screen.dart';
import 'package:fluttertest/ui/Admin/admin_home.dart';
import 'package:fluttertest/ui/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    try {
      // Đăng nhập bằng email & password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Lấy UID người dùng
      String uid = userCredential.user!.uid;

      // Lấy role từ Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Đăng nhập thành công!")));

        if (role == 'admin') {
          // 👉 Nếu là admin
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
            (route) => false,
          );
        } else {
          // 👉 Nếu là user bình thường
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không tìm thấy thông tin người dùng!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi đăng nhập: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Chào mừng trở lại",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Hãy điền thông tin đăng nhập của bạn",
                  style: TextStyle(fontSize: 16, color: Color(0xffABEB68)),
                ),
                SizedBox(height: 24),

                // 🔹 Input Email
                _buildTextField("Email", _emailController),
                SizedBox(height: 16),

                // 🔹 Input Password
                _buildPasswordField(),
                SizedBox(height: 8),

                // 🔹 Quên mật khẩu
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {}, // Thêm chức năng quên mật khẩu sau
                    child: Text(
                      "Bạn quên mật khẩu?",
                      style: TextStyle(color: Color(0xffABEB68)),
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // 🔹 Nút Đăng nhập
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _signIn, // Gọi hàm đăng nhập
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffABEB68),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Tiếp tục",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // 🔹 Đăng ký tài khoản mới
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bạn chưa có tài khoản?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/register",
                        ); // Điều hướng sang trang đăng ký
                      },
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(color: Color(0xffABEB68)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📌 Widget Input Text Field (Email & Password)
  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Color(0xffBABCB5)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // 📌 Widget Password Field
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: "Mật khẩu",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Color(0xffBABCB5)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
