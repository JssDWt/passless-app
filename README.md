# passless_android

App to store receipts via NFC.

## Notes
Currently only the Android version implements NFC.
iOS is a work in progress.

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