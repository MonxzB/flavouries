import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'package:fluttertest/ui/main_screen.dart'; // Main screen
import 'package:fluttertest/Screens/home_screen.dart'; // Home screen

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _agreeToTerms = false;
  bool _isLoading = false; // Loading state

  // 📌 Hàm đăng ký người dùng và gán vai trò mặc định
  Future<void> _register() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đồng ý với điều khoản')),
      );
      return;
    }

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    // Validate email
    if (!_validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập địa chỉ email hợp lệ')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Đăng ký người dùng mới với Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        // Cập nhật tên người dùng trong Firebase Authentication
        await user.updateDisplayName(name);
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        // Lưu thông tin người dùng vào Firestore
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
          {
            'user_id':
                user.uid, // Lưu user_id là UID của Firebase Authentication
            'name': name,
            'email': email,
            'avatar_url': user.photoURL ?? '', // Nếu có URL avatar, lưu vào đây
            'role': 'user', // Set role to 'user' by default
            'created_at':
                FieldValue.serverTimestamp(), // Thời gian tạo tài khoản
          },
        );

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đăng ký thành công! Xin chào ${user.displayName}'),
          ),
        );

        // ✅ Điều hướng về MainScreen với Navbar
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false, // Xóa tất cả các màn hình trước đó
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      print('Lỗi đăng ký: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi đăng ký: $e')));
    }
  }

  // Email validation function
  bool _validateEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Chào mừng bạn đến với Flavouries',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Hãy điền thông tin bên dưới để đăng ký'),
              const SizedBox(height: 30),
              _buildTextField('Tên của bạn', _nameController),
              const SizedBox(height: 16),
              _buildTextField(
                'Email hoặc số điện thoại',
                _emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              _buildTermsCheckbox(),
              const SizedBox(height: 16),
              // Show loading indicator while registering
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffABEB68),
                    ),
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 Widget Input Text Field (Email & Password)
  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  // 📌 Widget Password Field
  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value ?? false;
            });
          },
        ),
        const Text('Đồng ý với các điều khoản'),
      ],
    );
  }
}
