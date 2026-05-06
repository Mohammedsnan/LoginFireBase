import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home_screenPage.dart' show HomeScreen;
import 'Admin Login/Admin_Login.dart';
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
  final AuthServiceadmin authServicesadmin = AuthServiceadmin();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isAdminLogin = false;
  bool _isLoginMode = true; // true = تسجيل دخول, false = إنشاء حساب

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isAdminLogin) {
        // تسجيل دخول المدير
        bool success = await authServicesadmin.adminLogin(
          emailController.text.trim(),
          passwordController.text,
        );

        if (success) {
          if (!mounted) return;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) =>  AuthServiceadmin()),
          // );
        } else {
          _showError('بيانات الدخول غير صحيحة');
        }
      } else if (_isLoading) {
        // تسجيل دخول عميل
        User? user = (await authServicesignIn.signIn(
          emailController.text.trim(),
          passwordController.text,
        )) as User?;

        if (user != null) {
          if (!mounted) return;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const ProductsPage()),
          // );
        } else {
          _showError('بيانات الدخول غير صحيحة');
        }
      } else {
        // تسجيل عميل جديد
        User? user = (await authServicesignUp.signUp(
          emailController.text.trim(),
          passwordController.text,
        )) as User?;

        if (user != null) {
          if (!mounted) return;
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const ProductsPage()),
          // );
        } else {
          _showError('حدث خطأ أثناء التسجيل');
        }
      }
    } catch (e) {
      _showError(e.toString());
    }

    setState(() => _isLoading = false);
  }
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors:[
              Colors.yellow ,
             Colors.yellowAccent ,
            ],
            ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // التبديل بين تسجيل الدخول للمدير والعميل
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAdminLogin = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isAdminLogin ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'أنا عميل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_isAdminLogin ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isAdminLogin = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isAdminLogin ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'صاحب العمل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isAdminLogin ? Colors.white : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //  شعار التطبيق (اختياري
              Icon(
                _isLoginMode ? Icons.lock : Icons.person_add,
                size: 60,
                color: Colors.white,
              ),
              Text(
                _isAdminLogin ? 'تسجيل دخول المدير' : (_isLoading ? 'تسجيل الدخول' : 'إنشاء حساب جديد'),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30), //  حقل البريد الإلكتروني
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade400,
                  labelText: _isAdminLogin ? 'البريد الإلكتروني للمدير' : 'البريد الإلكتروني',
                  hintText: "example@email.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.email,),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'البريد مطلوب';
                  if (!v!.contains('@')) return 'بريد غير صحيح';
                  return null;
                },
              ),
              SizedBox(height: 15),
              //  حقل كلمة المرور
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade400,
                  labelText: "كلمة المرور",
                  hintText: "********",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) => v?.isEmpty ?? true ? 'كلمة المرور مطلوبة' : null,

              ),
              SizedBox(height: 15),
              //  حقل تأكيد كلمة المرور (يظهر فقط في وضع إنشاء الحساب)
              if (!_isLoginMode) ...[
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey.shade400,
                    labelText: "تأكيد كلمة المرور",
                    hintText: "********",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (v) => v?.isEmpty ?? true ? 'رقم الجوال مطلوب' : null,

                ),
                SizedBox(height: 15),
              ], //  زر تسجيل الدخول / إنشاء حساب
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading ?
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(_isAdminLogin ? 'دخول المدير' : (_isLoading ? 'دخول' : 'تسجيل'),
                    style: const TextStyle(fontSize: 18)),

              ),
               const SizedBox(height: 10),
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
                  style: TextStyle(color: Colors.black),
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
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                    Text("تسجيل الدخول بواسطة Google" ,style: TextStyle(color: Colors.black),),
                  ],
                ),

              ),
            ],
          ),
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