// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
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
  get localeName => 'messages';

  static m0(howMany) => "${Intl.plural(howMany, one: 'You will not be able to recover the receipt later.', other: 'You will not be able to recover the receipts later.')}";

  static m1(howMany) => "${Intl.plural(howMany, one: 'Delete receipt?', other: 'Delete ${howMany} receipts?')}";

  static m2(howMany) => "${Intl.plural(howMany, one: '${howMany} selected', other: '${howMany} selected')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "addNotesTooltip" : MessageLookupByLibrary.simpleMessage("Add notes"),
    "cancelEditTooltip" : MessageLookupByLibrary.simpleMessage("Cancel edit"),
    "clearTooltip" : MessageLookupByLibrary.simpleMessage("Clear"),
    "cloudBackup" : MessageLookupByLibrary.simpleMessage("Cloud backup"),
    "data" : MessageLookupByLibrary.simpleMessage("Data"),
    "deleteNotesTooltip" : MessageLookupByLibrary.simpleMessage("Delete notes"),
    "deleteReceiptsDialogMessage" : m0,
    "deleteReceiptsDialogTitle" : m1,
    "editNotesTooltip" : MessageLookupByLibrary.simpleMessage("Edit notes"),
    "enable" : MessageLookupByLibrary.simpleMessage("ENABLE"),
    "language" : MessageLookupByLibrary.simpleMessage("Language"),
    "latestReceiptsTitle" : MessageLookupByLibrary.simpleMessage("Latest receipts"),
    "lessButtonLabel" : MessageLookupByLibrary.simpleMessage("LESS"),
    "localization" : MessageLookupByLibrary.simpleMessage("Localization"),
    "moreButtonLabel" : MessageLookupByLibrary.simpleMessage("MORE"),
    "newReceiptTitle" : MessageLookupByLibrary.simpleMessage("New receipt"),
    "nfc" : MessageLookupByLibrary.simpleMessage("NFC"),
    "nfcDisabled" : MessageLookupByLibrary.simpleMessage("NFC is disabled."),
    "nfcEnabled" : MessageLookupByLibrary.simpleMessage("NFC is enabled."),
    "noReceiptsFound" : MessageLookupByLibrary.simpleMessage("No receipts found"),
    "notes" : MessageLookupByLibrary.simpleMessage("Notes"),
    "receipt" : MessageLookupByLibrary.simpleMessage("Receipt"),
    "receiptsSelectedTitle" : m2,
    "saveNotesTooltip" : MessageLookupByLibrary.simpleMessage("Save notes"),
    "settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "tax" : MessageLookupByLibrary.simpleMessage("Tax"),
    "title" : MessageLookupByLibrary.simpleMessage("Passless"),
    "total" : MessageLookupByLibrary.simpleMessage("Total")
  };
}
