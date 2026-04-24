import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home_screenPage.dart' show HomeScreen;
import 'GoogleSignIn/signInWithGoogleService.dart';
import 'SigUp/signUpService.dart';
import 'SignIN/SignInSerivce.dart' show AuthServicesignIn;


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthService authService = AuthService();
  final AuthServicesignIn authServicesignIn = AuthServicesignIn();
  final AuthServicesignUp authServicesignUp = AuthServicesignUp();

  bool _isLoading = false;
  bool _isLoginMode = true; // true = تسجيل دخول, false = إنشاء حساب

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? "تسجيل الدخول" : "إنشاء حساب جديد"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ //  شعار التطبيق (اختياري
            Icon(
              _isLoginMode ? Icons.lock : Icons.person_add,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 30), //  حقل البريد الإلكتروني
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "البريد الإلكتروني",
                hintText: "example@email.com",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 15),
            //  حقل كلمة المرور
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "كلمة المرور",
                hintText: "********",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 15),
            //  حقل تأكيد كلمة المرور (يظهر فقط في وضع إنشاء الحساب)
            if (!_isLoginMode) ...[
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "تأكيد كلمة المرور",
                  hintText: "********",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              SizedBox(height: 15),
            ], //  زر تسجيل الدخول / إنشاء حساب
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                if (_isLoginMode) {
                  await _handleSignIn();
                } else {
                  await _handleSignUp();
                }
              },
              child: _isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(_isLoginMode ? "تسجيل الدخول" : "إنشاء حساب"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            //  تبديل وضع تسجيل الدخول / إنشاء حساب
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode;
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                });
              },
              child: Text(
                _isLoginMode
                    ? "ليس لديك حساب؟ إنشاء حساب جديد"
                    : "لديك حساب بالفعل؟ تسجيل الدخول",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: _isLoading ? null : () async {
                setState(() => _isLoading = true);
                final result = await authService.signInWithGoogle();
                setState(() => _isLoading = false);
                if (result['success'] == true) {
                  _showSnackBar(result['message'], Colors.green);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                  );
                } else {
                  _showSnackBar(result['message'], Colors.red);
                }
              },
              child: _isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 15),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.g_mobiledata_outlined, size: 24, color: Colors.red),
                  SizedBox(width: 10),
                  Text("تسجيل الدخول بواسطة Google"),
                ],
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //  دالة إنشاء حساب جديد
  Future<void> _handleSignUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    if (email.isEmpty) {
      _showSnackBar(' الرجاء إدخال البريد الإلكتروني', Colors.red);
      return;
    }if (password.isEmpty) {
      _showSnackBar(' الرجاء إدخال كلمة المرور', Colors.red);
      return;
    }if (password.length < 6) {
      _showSnackBar(' كلمة المرور يجب أن تكون 6 أحرف على الأقل', Colors.red);
      return;
    }if (password != confirmPassword) {
      _showSnackBar(' كلمة المرور غير متطابقة مع تأكيد كلمة المرور', Colors.red);
      return;
    }
    setState(() => _isLoading = true);
    final result = await authServicesignUp.signUp(email, password);
    setState(() => _isLoading = false);
    if (result['success'] == true) {
      _showSnackBar(result['message'], Colors.green);
      User? user = result['user'];
      print(' تم إنشاء حساب للمستخدم: ${user?.email}');
      print(' UID: ${user?.uid}');
      print(' تاريخ الإنشاء: ${user?.metadata.creationTime}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      _showSnackBar(result['message'], Colors.red);
    }
  }
  // دالة تسجيل الدخول
  Future<void> _handleSignIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty) {
      _showSnackBar(' الرجاء إدخال البريد الإلكتروني', Colors.red);
      return;
    }if (password.isEmpty) {
      _showSnackBar(' الرجاء إدخال كلمة المرور', Colors.red);
      return;
    }
    setState(() => _isLoading = true);
    final result = await authServicesignIn.signIn(email, password);
    setState(() => _isLoading = false);
    if (result['success'] == true) {
      _showSnackBar(result['message'], Colors.green);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      _showSnackBar(result['message'], Colors.red);
    }
  }
  // عرض رسائل للمستخدم
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}