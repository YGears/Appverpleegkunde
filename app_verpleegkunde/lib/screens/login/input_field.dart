import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String input;

  InputField(this.input);

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(input)]);
  }
}
