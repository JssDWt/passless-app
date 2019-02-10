import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String apiBaseUrl;

  AppConfig({
    @required this.apiBaseUrl,
    @required Widget child,
  }) : assert(apiBaseUrl != null),
       assert(child != null),
       super(child: child);

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}