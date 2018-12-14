import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "appBarLeading",
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        )
      )
    );
  }

}