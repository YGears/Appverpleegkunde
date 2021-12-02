import 'package:flutter/material.dart';

class ImageCover extends StatelessWidget {
  final String _assetPath;

  // ignore: use_key_in_widget_constructors
  const ImageCover(this._assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(child: Image.asset(_assetPath, fit: BoxFit.cover));
  }
}
