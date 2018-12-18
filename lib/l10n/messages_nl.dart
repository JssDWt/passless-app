// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'nl';

  static m0(howMany) => "${Intl.plural(howMany, one: 'De bon kan later niet worden hersteld.', other: 'De bonnen kunnen later niet worden hersteld.')}";

  static m1(howMany) => "${Intl.plural(howMany, one: 'Bon verwijderen?', other: '${howMany} bonnen verwijderen?')}";

  static m2(howMany) => "${Intl.plural(howMany, one: '${howMany} geselecteerd', other: '${howMany} geselecteerd')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addNotesTooltip" : MessageLookupByLibrary.simpleMessage("Notities toevoegen"),
    "cancelEditTooltip" : MessageLookupByLibrary.simpleMessage("Wijzigingen annuleren"),
    "clearTooltip" : MessageLookupByLibrary.simpleMessage("Wissen"),
    "cloudBackup" : MessageLookupByLibrary.simpleMessage("Cloud backup"),
    "data" : MessageLookupByLibrary.simpleMessage("Data"),
    "deleteNotesTooltip" : MessageLookupByLibrary.simpleMessage("Notities verwijderen"),
    "deleteReceiptsDialogMessage" : m0,
    "deleteReceiptsDialogTitle" : m1,
    "editNotesTooltip" : MessageLookupByLibrary.simpleMessage("Notities wijzigen"),
    "enable" : MessageLookupByLibrary.simpleMessage("ACTIVEREN"),
    "language" : MessageLookupByLibrary.simpleMessage("Taal"),
    "latestReceiptsTitle" : MessageLookupByLibrary.simpleMessage("Nieuwste bonnen"),
    "localization" : MessageLookupByLibrary.simpleMessage("Regionale instellingen"),
    "newReceiptTitle" : MessageLookupByLibrary.simpleMessage("Nieuwe bon"),
    "nfc" : MessageLookupByLibrary.simpleMessage("NFC"),
    "nfcDisabled" : MessageLookupByLibrary.simpleMessage("NFC is gedeactiveerd."),
    "nfcEnabled" : MessageLookupByLibrary.simpleMessage("NFC is geactiveerd."),
    "noReceiptsFound" : MessageLookupByLibrary.simpleMessage("Geen bonnen gevonden"),
    "notes" : MessageLookupByLibrary.simpleMessage("Notities"),
    "receiptsSelectedTitle" : m2,
    "saveNotesTooltip" : MessageLookupByLibrary.simpleMessage("Notities opslaan"),
    "settings" : MessageLookupByLibrary.simpleMessage("Instellingen"),
    "tax" : MessageLookupByLibrary.simpleMessage("BTW"),
    "title" : MessageLookupByLibrary.simpleMessage("Passless"),
    "total" : MessageLookupByLibrary.simpleMessage("Totaal")
  };
}
