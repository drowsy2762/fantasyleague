import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      home: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final client = SupabaseClient('https:/ㅠ/your-project-id.supabase.co', 'your-public-anon-key');

  void login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await client.auth.signIn(
      email: email,
      password: password,
    );

    if (response.error != null) {
      // Handle error
      print('Login failed: ${response.error!.message}');
    } else {
      // Handle success
      print('Login successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log in'),
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {
          // TODO: Implement your logic here
        }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {
            // TODO: Implement your logic here
          })
        ],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Center(
            child: Image(
              image: AssetImage('assets/images/munji.png'), // Make sure the path to the image is correct
              width: 170.0,
            ),
          ),
          Form(
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
                child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Enter email'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(labelText: 'Enter password'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          SizedBox(height: 40.0,),
                          ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: login,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 35.0,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent
                                ),
                              )
                          )
                        ],
                      ),
                    )),
              ))
        ],
      ),
    );
  }
}