import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fantasyleague/LoginScreen.dart';
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
                try {
                  final AuthResponse res = await supabase.auth.signUp(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  if (res.user != null) {
                    print('success to register');
                    await supabase
                        .from('users')
                        .insert({'user_uid': res.user!.id,'room_id': []});

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to Register. Please try again.')),
                    );
                    print('Failed to sign up');
                  }
                } catch (e) {
                  if (e is AuthException && e.message == 'User already registered') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email is already in use. Please use a different email.')),
                    );
                  } else {
                    print(e);
                  }
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}