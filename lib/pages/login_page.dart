import 'package:flutter/material.dart';
import 'package:flutter_chat/components/text_field.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

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

          CustomTextField(
            hintText: "Email...",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 15),

          CustomTextField(
            hintText: "Password...",
            obscureText: true,
            controller: _passwordController,
          ),

          const SizedBox(height: 15),

        ],
      ),
    );
  }
}