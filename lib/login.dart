import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final response = await supabase.auth.signUp(
                  email: emailController.text,
                  password: passwordController.text,
                );

                if (response.session == null) {
                  // Login successful
                  print('User logged in successfully');
                } else {
                  // Handle login error
                  print('Login error: ${response.user}');
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}