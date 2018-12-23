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

  String get clearTooltip {
    return Intl.message(
      'Clear',
      name: 'clearTooltip',
      desc: 'Tooltip over the clear button',
    );
  }

  String get title {
    return Intl.message(
      'Passless',
      name: 'title',
      desc: 'Title for the Passless application',
    );
  }

  String get newReceiptTitle {
    return Intl.message(
      'New receipt',
      name: 'newReceiptTitle',
      desc: 'Page title for a new receipt',
    );
  }

  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: 'Word for settings',
    );
  }

  String get nfc {
    return Intl.message(
      'NFC',
      name: 'nfc',
      desc: 'abbreviation for Near Field Communication',
    );
  }

  String get nfcEnabled {
    return Intl.message(
      'NFC is enabled.',
      name: 'nfcEnabled',
      desc: 'Short sentence indicating nfc is enabled.',
    );
  }

  String get nfcDisabled {
    return Intl.message(
      'NFC is disabled.',
      name: 'nfcDisabled',
      desc: 'Short sentence indicating nfc is disabled.',
    );
  }

  String get enable {
    return Intl.message(
      'ENABLE',
      name: 'enable',
      desc: 'Text on button that enables nfc.',
    );
  }

  String get data {
    return Intl.message(
      'Data',
      name: 'data',
      desc: 'Header text over the data settings menu container.',
    );
  }

  String get cloudBackup {
    return Intl.message(
      'Cloud backup',
      name: 'cloudBackup',
      desc: 'Settings for cloud backup.',
    );
  }

  String get localization {
    return Intl.message(
      'Localization',
      name: 'localization',
      desc: 'Settings for localization (language, etc.).',
    );
  }

  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: 'Word for language.',
    );
  }

  String get latestReceiptsTitle {
    return Intl.message(
      'Latest receipts',
      name: 'latestReceiptsTitle',
      desc: 'Title for the latest receipts page',
    );
  }

  String deleteReceiptsDialogTitle(int howMany) {
    return Intl.plural(
      howMany,
      one: 'Delete receipt?',
      other: 'Delete $howMany receipts?',
      name: 'deleteReceiptsDialogTitle',
      args: [howMany],
      desc: 'Title for the delete receipts dialog. Indicating how many receipts will be deleted.',
    );
  }

  String deleteReceiptsDialogMessage(int howMany) {
    return Intl.plural(
      howMany,
      one: 'You will not be able to recover the receipt later.',
      other: 'You will not be able to recover the receipts later.',
      name: 'deleteReceiptsDialogMessage',
      args: [howMany],
      desc: 'Message for the delete receipts dialog. Indicating that the receipts cannot be recovered.',
    );
  }

  String receiptsSelectedTitle(int howMany) {
    return Intl.plural(
      howMany,
      one: '$howMany selected',
      other: '$howMany selected',
      name: 'receiptsSelectedTitle',
      args: [howMany],
      desc: 'Short ttext indicating how many receipts are selected.',
    );
  }

  String itemCount(int howMany) {
    return Intl.plural(
      howMany,
      one: '$howMany item',
      other: '$howMany items',
      name: 'itemCount',
      args: [howMany],
      desc: 'Indicates how many items are in a receipt.'
    );
  }
  
  String get noReceiptsFound {
    return Intl.message(
      'No receipts found',
      name: 'noReceiptsFound',
      desc: 'Text shown when no receipts were found in a search.',
    );
  }

  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: 'Text indicating total price',
    );
  }

  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: 'Word for tax',
    );
  }

  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: 'Word for notes',
    );
  }

  String get addNotesTooltip {
    return Intl.message(
      'Add notes',
      name: 'addNotesTooltip',
      desc: 'Imperative to add notes; tooltip over the add button',
    );
  }

  String get deleteNotesTooltip {
    return Intl.message(
      'Delete notes',
      name: 'deleteNotesTooltip',
      desc: 'Imperative to delete notes; tooltip over the delete button',
    );
  }

  String get editNotesTooltip {
    return Intl.message(
      'Edit notes',
      name: 'editNotesTooltip',
      desc: 'Imperative to edit notes; tooltip over the edit button',
    );
  }
  
  String get saveNotesTooltip {
    return Intl.message(
      'Save notes',
      name: 'saveNotesTooltip',
      desc: 'Imperative to save notes; tooltip over the save button',
    );
  }

  String get cancelEditTooltip {
    return Intl.message(
      'Cancel edit',
      name: 'cancelEditTooltip',
      desc: 'Imperative to cancel editing',
    );
  }

  String get receipt {
    return Intl.message(
      'Receipt',
      name: 'receipt',
      desc: 'Word for receipt',
    );
  }

  String get moreButtonLabel {
    return Intl.message(
      'MORE',
      name: 'moreButtonLabel',
      desc: 'Text on the more button. Shows when overflown text is cut.',
    );
  }

  String get lessButtonLabel {
    return Intl.message(
      'LESS',
      name: 'lessButtonLabel',
      desc: 'Text on the less button. Shows when large text can be hidden.',
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

  String quantity(double quantity, String unit) {
    // TODO: Implement all available units for produce
    var f = NumberFormat.decimalPattern(locale.toString());
    String result;
    switch (unit.toLowerCase()) {
      case "pc":
        result = f.format(quantity);
        break;
      case "kg":
      default:
        result = "${f.format(quantity)} $unit";
    }

    return result;
  }

  String date(DateTime date) {
    final f = DateFormat.yMMMMd(locale.toString());
    return f.format(date);
  }

  String time(DateTime time) {
    final f = DateFormat.Hm(locale.toString());
    return f.format(time);
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