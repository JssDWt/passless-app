import 'package:flutter/material.dart';
import 'package:passless_android/widgets/drawer_menu.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      body: Row(
        children: <Widget>[
          Text("Light"),
          Switch(
            value: false,
            onChanged: (newValue) {
              
            },),
          Text("Dark")
        ],
      )
    );
  }

}