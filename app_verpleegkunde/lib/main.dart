import 'package:flutter/material.dart';
import './screens/login/login.dart';
import 'app_colors.dart';


void main() => runApp(HanzeVerpleegkundeApp());

class HanzeVerpleegkundeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanze Verpleegkunde',
      theme: ThemeData(
          primaryColor: themeColor,
          scaffoldBackgroundColor: backgroundColor),
      home: const loginScreen(),
    );
  }
}
