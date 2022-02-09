import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screens/login/login.dart';
import 'app_colors.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const HanzeVerpleegkundeApp());
}

class HanzeVerpleegkundeApp extends StatelessWidget {
  const HanzeVerpleegkundeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanze Verpleegkunde',
      theme: ThemeData(
          primaryColor: themeColor, scaffoldBackgroundColor: backgroundColor),
      home: const LoginScreen(),
    );
  }
}
