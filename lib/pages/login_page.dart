import 'package:flutter/material.dart';
import 'package:flutter_chat/components/text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 50),

          Text(
            "Welcome Back!!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16
            ),
          ),

          const SizedBox(height: 25),

          CustomTextField(hintText: "Email..."),
          const SizedBox(height: 15),
          CustomTextField(hintText: "Password...")

        ],
      ),
    );
  }
}