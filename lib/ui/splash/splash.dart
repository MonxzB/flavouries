import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertest/Screens/Login/login_screen.dart';
import 'package:fluttertest/Screens/Signup/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentImageIndex = 0;

  final List<String> imageList = [
    "assets/images/on_boarding.png",
    "assets/images/on_boarding2.png",
    "assets/images/on_boarding3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageSlider(),
            _buildTextSplash(),
            _buildText2Splash(),
            _buildDotIndicators(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Positioned(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFABEB68).withOpacity(0.5),
              ),
            ),
          ),

          // Image Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              viewportFraction: 0.7,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            items:
                imageList.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(imagePath, fit: BoxFit.contain),
                      );
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicators() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            imageList.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentImageIndex == entry.key
                          ? const Color(0xFFABEB68)
                          : const Color(0xFFD8D8D8),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildTextSplash() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: const Text(
        "Dễ dàng tìm kiếm",
        style: TextStyle(
          color: Color(0xff32332E),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildText2Splash() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: const Text(
        "Tìm kiếm nhanh chóng theo thành phần món ăn",
        style: TextStyle(color: Color(0xff9FA196), fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFABEB68),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Tạo tài khoản",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF85CD19),
                side: const BorderSide(color: Color(0xFF85CD19), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Đăng nhập",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
