import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Screens/Login/login_screen.dart';
import 'package:fluttertest/Screens/Signup/signup_screen.dart';
import 'package:fluttertest/ui/splash/splash.dart';
import 'package:fluttertest/firebase_options.dart';
import 'package:fluttertest/ui/main_screen.dart'; // ✅ Import MainScreen()

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // ✅ Chạy SplashScreen trước
      routes: {
        '/splash': (context) => SplashScreen(), // ✅ Splash đầu tiên
        '/signup': (context) => RegisterScreen(), // ✅ Đăng ký
        '/login': (context) => LoginScreen(), // ✅ Đăng nhập
        '/home': (context) => MainScreen(), // ✅ Màn hình chính
      },
    );
  }
}
