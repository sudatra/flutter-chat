import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: LoginPage(),
    );
  }
}
