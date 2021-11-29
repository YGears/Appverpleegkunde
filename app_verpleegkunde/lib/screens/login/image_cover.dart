import 'package:flutter/material.dart';

class ImageCover extends StatelessWidget {
  final String _assetPath;

  ImageCover(this._assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(child: Image.asset(_assetPath, fit: BoxFit.cover));
  }
}
