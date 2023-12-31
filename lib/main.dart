import 'package:flutter/material.dart';
<<<<<<< HEAD

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
=======
import 'draft.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy League'),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Go to Draft Page'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FantasyLeagueDraft()),
            );
          },
        ),
      ),
    );
  }
}
>>>>>>> 408a80a (일단 main과 draftpage 분리 성공)
