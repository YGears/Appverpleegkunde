import 'package:flutter/material.dart';

class Style {
  BoxDecoration borderStyling() {
    return BoxDecoration(
      color: Colors.orange[50],
      border: Border.all(width: 3.0),
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    );
  }
}
