package com.example.passlessandroid;

import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.nfc.NfcAdapter;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.nio.charset.Charset;

public class MainActivity extends FlutterActivity {
  public static final String STATE_INTENT_HANDLED = 
    "com.example.passlessandroid.state.intent_processed";

  NfcAdapter nfcAdapter;
  PendingIntent nfcPendingIntent;
  IntentFilter[] nfcFilters;
  private boolean intentHandled = false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    Log.i("passless", "onCreate: begin");
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    // NfcPlugin.registerWith(this.registrarFor("NfcPlugin"));

    if(savedInstanceState != null) {
      intentHandled = savedInstanceState.getBoolean(STATE_INTENT_HANDLED);
    }

    this.setNfcSettings();
    
    

    Log.i("passless", "onCreate: end");
  }

  @Override
  public void onResume(){
    Log.i("passless", "onResume: begin");

    super.onResume();
    
    if (this.nfcAdapter != null) {
      nfcAdapter.enableForegroundDispatch(
        this, this.nfcPendingIntent, this.nfcFilters, null);
    }

    if (!intentHandled) {
      handleIntent();
    }

    Log.i("passless", "onResume: end");
  }

  @Override
  public void onPause() {
    Log.i("passless", "onPause: begin");

    super.onPause();
    
    if (this.nfcAdapter != null) {
      nfcAdapter.disableForegroundDispatch(this);
    }

    Log.i("passless", "onPause: end");
  }

  @Override
  protected void onNewIntent(Intent intent){
    Log.i("passless", "onNewIntent: begin");
    if (intent != null) {
      String action = intent.getAction();
      Log.i("passless", String.format("Intent action = '%s'", action));
      
      // onResume will handle the intent.
      this.intentHandled = false;

      // TODO: call setintent here? Or does flutter do that for us?
    }

    super.onNewIntent(intent);
    Log.i("passless", "onNewIntent: end");
  }

  @Override
  protected void onSaveInstanceState(Bundle outState) {
      super.onSaveInstanceState(outState);
      outState.putBoolean(STATE_INTENT_HANDLED, intentHandled);
  }

  private void setNfcSettings() {
    Log.i("passless", "setNfcSettings: begin");
    nfcAdapter = NfcAdapter.getDefaultAdapter(this);   
    if (nfcAdapter == null) {
        Log.i("passless", "nfc not supported by device.");
        return;
    }

    nfcFilters = new IntentFilter[] { 
      new IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED)
    };

    nfcPendingIntent = PendingIntent.getActivity(
      this, 
      0, 
      new Intent(this, getClass())
        .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 
      0);
    
    Log.i("passless", "setNfcSettings: end");
  }

  private void handleIntent() {
    Log.i("passless", "handleIntent: begin");
    intentHandled = true;
    Intent intent = getIntent();

    if (intent == null) {
      Log.i("passless", "intent is null, returning.");
      return;
    }

    if (!NfcAdapter.ACTION_NDEF_DISCOVERED.equals(intent.getAction())) {
      Log.i("passless", "intent action does not match ACTION_NDEF_DISCOVERED.");
      return;
    }

    Parcelable[] rawMessages =
      intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);

    if (rawMessages == null) {
      Log.i("passless", "rawMessages is null.");
    } else {
      Log.i("passless", 
        String.format("Found %d raw messages", rawMessages.length));
      NdefMessage[] messages = new NdefMessage[rawMessages.length];
      for (int i = 0; i < rawMessages.length; i++) {
          messages[i] = (NdefMessage) rawMessages[i];
      }
      
      for (int i = 0; i < messages.length; i++) {
        NdefRecord[] records = messages[i].getRecords();
        Log.i(
          "passless", 
          String.format("Message %d has %d records.", i, records.length));

        for(int j = 0; j < records.length; j++) {
          byte[] data = records[j].getPayload();
          String dataString = new String(data, Charset.defaultCharset());
          Log.i(
            "passless",
            String.format("Record %d, payload %d, data: %s", i, j, dataString));
        }
      }
    }
    Log.i("passless", "handleIntent: end");
  }
}