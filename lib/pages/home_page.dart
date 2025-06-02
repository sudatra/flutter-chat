import 'package:flutter/material.dart';
import 'package:flutter_chat/components/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Home", textAlign: TextAlign.center)
        ),
        backgroundColor: Theme.of(context).colorScheme.primary
      ),
      drawer: CustomDrawer(),
    );
  }
}