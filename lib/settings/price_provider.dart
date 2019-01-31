import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/models/preferences.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/settings/preferences_provider.dart';

class PriceProvider{
  final Preferences preferences;
  final BuildContext context;
  PriceProvider(this.preferences, this.context);

  static PriceProvider of(BuildContext context) {
    var pref = PreferencesProvider.of(context);
    return PriceProvider(pref.preferences, context);
  }

  String price(Price price, String currency) {
    return _price(price, currency, false);
  }

  String negativePrice(Price price, String currency) {
    return _price(price, currency, true);
  }

  String _price(Price price, String currency, bool negative) {
    double amount = preferences.includeTax ? price.withTax : price.withoutTax;
    if (negative) amount = -amount;
    return PasslessLocalizations.of(context).price(amount, currency);
  }
}