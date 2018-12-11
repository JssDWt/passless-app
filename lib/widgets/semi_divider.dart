import 'package:flutter/material.dart';

class SemiDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider()
    );
  }
}