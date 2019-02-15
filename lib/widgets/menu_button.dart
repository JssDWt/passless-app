import 'package:flutter/material.dart';
import 'package:passless/widgets/appbar_button.dart';
import 'package:passless/widgets/spinning_hero.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinningHero(
      tag: "appBarLeading",
      child: AppBarButton(
        icon: Icon(Icons.menu),
        tooltip: MaterialLocalizations.of(context).drawerLabel,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }
}