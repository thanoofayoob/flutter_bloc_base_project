import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Login Screen'),
              IconButton(onPressed: () {}, icon: const Icon(Icons.login)),
            ],
          ),
        ),
      ),
    );
  }
}
