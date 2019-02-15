import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final String tooltip;
  AppBarButton({@required this.icon, this.onPressed, @required this.tooltip})
    : assert(icon != null),
      assert(tooltip != null);
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconTheme(
        data: Theme.of(context).primaryIconTheme,
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
        )
      )
    );
  }
}