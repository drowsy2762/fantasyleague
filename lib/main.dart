import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'draft.dart';
import 'LoginScreen.dart';

Future<void> main() async {
  Supabase.initialize(url: 'https://vwjdztadfyfukborxnwe.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3amR6dGFkZnlmdWtib3J4bndlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTk4NTI5MDcsImV4cCI6MjAxNTQyODkwN30.lZEFlILH5YkjGS-CWzYn5GQy8y5nRi8mw9SY27viq9A'
  );

  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LoginScreen(),
    );
  }
}