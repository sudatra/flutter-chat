import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: Text("Settings", textAlign: TextAlign.center)
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
    );
  }
}