// login_view.dart
import 'dart:async';
import 'package:flutter/material.dart';
// Import Controller milik sendiri (masih satu folder)
import 'package:logbook_app_083/features/auth/login_controller.dart';
// Import View dari fitur lain (Logbook) untuk navigasi
import 'package:logbook_app_083/features/logbook/log_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Inisialisasi Otak dan Controller Input
  final LoginController _controller = LoginController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isObscure = true;
  bool _isLocked = false;
  int _attemptCount = 0;
  Timer? _lockoutTimer;

  void _handleLogin() {
    String user = _userController.text;
    String pass = _passController.text;

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan Password tidak boleh kosong!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool isSuccess = _controller.login(user, pass);

    if (isSuccess) {
      setState(() {
        _attemptCount = 0;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Di sini kita kirimkan variabel 'user' ke parameter 'username' di CounterView
          builder: (context) => LogView(username: user),
        ),
      );
    } else {
      setState(() {
        _attemptCount++;
      });
      if (_attemptCount >= 3) {
        setState(() {
          _isLocked = true;
        });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Salah 3x. Login dikunci selama 10 detik."),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      _lockoutTimer = Timer(const Duration(seconds: 10), () {
          setState(() {
            _isLocked = false;
            _attemptCount = 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Silakan coba login kembali.")),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Gagal! Sisa percobaan: ${3 - _attemptCount}")),
        );
      }
    }
  }

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Gatekeeper")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passController,
              obscureText: _isObscure, // Menyembunyikan teks password
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLocked ? null : _handleLogin, 
                child: Text(_isLocked ? "Terkunci (Tunggu...)" : "Masuk"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}