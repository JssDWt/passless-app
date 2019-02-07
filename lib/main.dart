import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nfc/nfc_provider.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/receipt_app.dart';
import 'package:passless/settings/preferences_provider.dart';
import 'package:passless/utils/app_config.dart';

/// Main entry point for the app.
void main() {
  runApp(ReceiptMaterialApp());
}

/// Root class for the material app.
class ReceiptMaterialApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReceiptMaterialAppState();
}

/// Defines material app state like the theme.
class _ReceiptMaterialAppState extends State<ReceiptMaterialApp> {
  @override
  Widget build(BuildContext context) {
    return AppConfig(
      apiBaseUrl: "http://10.0.2.2:5000/api/",
      child: NfcProvider(
        child: PreferencesProvider(
          child: MaterialApp(
            localizationsDelegates: [
              const PasslessLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('nl', 'NL')
            ],
            debugShowCheckedModeBanner: false, 
            theme: ThemeData.light(), 
            home: ReceiptApp(),
          ),
        ),
      )
    );
  }
}
