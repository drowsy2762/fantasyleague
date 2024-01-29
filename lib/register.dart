import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                final AuthResponse res = await supabase.auth.signUp(
                  email: emailController.text,
                  password: passwordController.text,
                );

                if (res.session == null) {
                  // Registration successful
                  print('User registered successfully');
                } else {
                  // Handle registration error
                  print('Registration error: ${res.user}');
                }
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await supabase.auth.signInWithSSO(
                  domain: "google.com"
                );
                print(response);
              },
              child: Text('Sign Up with Google'),
            ),
          ],
        ),
      ),
    );
  }
}