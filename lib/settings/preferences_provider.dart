import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/preferences.dart';
import 'package:passless/models/receipt.dart';

class PreferencesProvider extends StatefulWidget {
  final Widget child;
  PreferencesProvider({@required this.child})
    : assert(child != null);

  @override
  _PreferencesProviderState createState() => _PreferencesProviderState();

  static _PreferencesProviderState of(BuildContext context) {
    final _PreferencesProvider provider = 
      context.inheritFromWidgetOfExactType(_PreferencesProvider);
    return provider._state;
  }
}

class _PreferencesProviderState extends State<PreferencesProvider> {
  Preferences _preferences;
  Preferences get preferences => _preferences;

  @override 
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    var preferences = await Repository().getPreferences();
    if (!mounted) return;

    setState(() {
      this._preferences = preferences;
    });
  }

  Future<void> updatePreferences(Preferences preferences) async {
    await Repository().updatePreferences(preferences);
    await _initPreferences();
  }

  String price(Price price, String currency) {
    double amount = preferences.includeTax ? price.withTax : price.withoutTax;
    return PasslessLocalizations.of(context).price(amount, currency);
  }

  String negativePrice(Price price, String currency) {
    double amount = preferences.includeTax ? price.withTax : price.withoutTax;
    return PasslessLocalizations.of(context).price(-amount, currency);
  }

  @override
  Widget build(BuildContext context) {
    var child = preferences == null 
      ? Center(child: CircularProgressIndicator()) : widget.child;
    return _PreferencesProvider(this, child: child);
  }
}  

class _PreferencesProvider extends InheritedWidget {
  final _PreferencesProviderState _state;
  _PreferencesProvider(this._state, { Key key, Widget child }) 
    : super(key: key, child: child );

  @override
  bool updateShouldNotify(_PreferencesProvider oldWidget) => false;
}