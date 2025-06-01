import 'package:flutter/material.dart';
import 'package:flutter_chat/auth/login_or_register.dart';
import 'package:flutter_chat/themes/light_mode.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: LoginOrRegister(),
      theme: lightMode,
    );
  }
}
