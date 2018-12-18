import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passless_android/l10n/messages_all.dart';


class PasslessLocalizations {
  final Locale locale;

  PasslessLocalizations(this.locale);

  static Future<PasslessLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return PasslessLocalizations(locale);
    });
  }

  static PasslessLocalizations of(BuildContext context) {
    return Localizations.of<PasslessLocalizations>(
      context, 
      PasslessLocalizations
    );
  }

  String get title {
    return Intl.message(
      'Passless',
      name: 'title',
      desc: 'Title for the Passless application',
    );
  }

  String price(double price, String currency) {
    var numberFormat = NumberFormat.compactSimpleCurrency(
      locale: locale.toString(), 
      name: currency);
    var formattedPrice = numberFormat.format(price);
    print('price $price and currency $currency returns $formattedPrice for locale $locale');
    return formattedPrice;
  }
}

class PasslessLocalizationsDelegate extends 
  LocalizationsDelegate<PasslessLocalizations> {
  const PasslessLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'nl'].contains(locale.languageCode);

  @override
  Future<PasslessLocalizations> load(Locale locale) 
    => PasslessLocalizations.load(locale);

  @override
  bool shouldReload(PasslessLocalizationsDelegate old) => false;
}