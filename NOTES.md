## Notes to self
In order to test NFC functionality, write a test that does something like this:
```java
Intent techIntent = new Intent(NfcAdapter.ACTION_NDEF_DISCOVERED);
techIntent.putExtra(NfcAdapter.EXTRA_ID, tagId);
techIntent.putExtra(NfcAdapter.EXTRA_TAG, mockTag);
techIntent.putExtra(NfcAdapter.EXTRA_NDEF_MESSAGES, new NdefMessage[]{ myNdefMessage });  

// or
NdefRecord mimeRecord = NdefRecord.createMime(
    "application/passless+json",
    "{ \"message\": \"NDEF message received\" }".getBytes(Charset.forName("UTF-8")));
```


To generate localization files, run:
`flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/l10n/passless_localizations.dart lib/main.dart`

`flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n \ --no-use-deferred-loading lib/l10n/passless_localizations.dart lib/main.dart lib/l10n/intl_*.arb`


In order to generate launcher icons for android and iOS, run:
`flutter packages pub run flutter_launcher_icons:main`


To generate json serializable classes, run:
`flutter packages pub run build_runner build`
or:
`flutter packages pub run build_runner build --delete-conflicting-outputs`
and if those fail, try:
`flutter packages pub run build_runner clean`