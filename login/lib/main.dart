import 'package:flutter/material.dart';
import 'account/register.dart';
import 'account/login.dart';
import 'home/home.dart';

main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          accentColor: Colors.amberAccent,
          buttonColor: Colors.blue),
      // home: AuthPage(),  this is replaced by routes '/'
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
