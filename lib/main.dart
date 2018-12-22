import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:nfc/nfc_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/receipt_app.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    return NfcProvider(
      child: DataProvider(
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
      )
    );
  }
}
