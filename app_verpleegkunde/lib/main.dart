import 'package:flutter/material.dart';
import './screens/login/login.dart';

void main() => runApp(HanzeVerpleegkundeApp());

class HanzeVerpleegkundeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanze Verpleegkunde',
      theme: ThemeData(
        primaryColor: Colors.orange, //BRING TO COLORS FILE
        scaffoldBackgroundColor: Colors.white, //BRING TO COLORS FILE
      ),
      home: const loginScreen(),
    );
  }
}
