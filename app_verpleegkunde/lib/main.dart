import 'package:flutter/material.dart';
import './screens/login/login.dart';

void main() => runApp(HanzeVerpleegkundeApp());

class HanzeVerpleegkundeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanze Verpleegkunde',
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const loginScreen(),
    );
  }
}
