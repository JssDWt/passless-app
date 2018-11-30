package com.example.passlessandroid;

import android.app.Activity;
import android.app.Application;
import android.app.Application.ActivityLifecycleCallbacks;
import android.content.Intent;
import android.app.PendingIntent;
import android.os.Bundle;
import android.os.Parcelable;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.BroadcastReceiver;
import android.nfc.NfcAdapter;
import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.util.Log;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.NewIntentListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.nio.charset.Charset;

public class NfcPlugin implements MethodCallHandler, StreamHandler, 
  NewIntentListener, ActivityLifecycleCallbacks {
    static final String STREAM = "flutter.passless.com/nfc-stream";
    static final String CHANNEL = "flutter.passless.com/nfc-channel";
    static final String STATE_INTENT_HANDLED = 
      "com.example.passlessandroid.state.intent_handled";
    static final String LOGNAME = "NfcPlugin";
    private final Registrar registrar;
    private final Activity activity;
    private ActivityLifecycleCallbacks activityLifecycleCallbacks;
    NfcAdapter nfcAdapter;
    PendingIntent nfcPendingIntent;
    IntentFilter[] nfcFilters;
    private boolean intentHandled = false;

    public static void registerWith(PluginRegistry.Registrar registrar) {
      Log.i(LOGNAME, "registerWith: begin");
      final MethodChannel methodChannel =
        new MethodChannel(registrar.messenger(), CHANNEL);
      final EventChannel eventChannel =
        new EventChannel(registrar.messenger(), STREAM);
      final NfcPlugin plugin = new NfcPlugin(registrar, registrar.activity());
      eventChannel.setStreamHandler(plugin);
      methodChannel.setMethodCallHandler(plugin);
      registrar.addNewIntentListener(plugin);
      plugin.activity.getApplication()
        .registerActivityLifecycleCallbacks(plugin);
      Log.i(LOGNAME, "registerWith: end");
    }
  
    private NfcPlugin(Registrar registrar, Activity activity) {
      Log.i(LOGNAME, "constructor: begin");
      this.registrar = registrar;
      this.activity = activity;
      Log.i(LOGNAME, "constructor: end");
    }

    @Override
    public void onActivityCreated(
      Activity activity, 
      Bundle savedInstanceState) {
        Log.i(LOGNAME, "onActivityCreated: begin");
        if (activity == this.activity) {
          if(savedInstanceState != null) {
            intentHandled = savedInstanceState.getBoolean(STATE_INTENT_HANDLED);
          }
      
          setNfcSettings();
        }
      
        Log.i(LOGNAME, "onActivityCreated: end");
    }

    @Override
    public void onActivityStarted(Activity activity) {}

    @Override
    public void onActivityResumed(Activity activity) {
      Log.i(LOGNAME, "onActivityResumed: begin");
      if (activity == this.activity) {
        if (nfcAdapter != null) {
          nfcAdapter.enableForegroundDispatch(
            this.activity, 
            nfcPendingIntent, 
            nfcFilters, 
            null);
        }
    
        if (!intentHandled) {
          handleIntent();
        }
      }

      Log.i(LOGNAME, "onActivityResumed: end");
    }

    @Override
    public void onActivityPaused(Activity activity) {
      Log.i(LOGNAME, "onActivityPaused: begin");
      if (activity == this.activity) {
        if (nfcAdapter != null) {
          nfcAdapter.disableForegroundDispatch(this.activity);
        }
      }

      Log.i(LOGNAME, "onActivityPaused: end");
    }

    @Override
    public void onActivityStopped(Activity activity) { }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
      Log.i(LOGNAME, "onActivitySaveInstanceState: begin");
      if (activity == this.activity) {
        outState.putBoolean(STATE_INTENT_HANDLED, intentHandled);
      }

      Log.i(LOGNAME, "onActivitySaveInstanceState: end");
    }

    @Override
    public void onActivityDestroyed(Activity activity) { }

    @Override
    public boolean onNewIntent(Intent intent) {
      Log.i(LOGNAME, "onNewIntent: begin");
      if (intent == null) {
        Log.i(LOGNAME, "onNewIntent: intent is null.");
        return false;
      }

      String action = intent.getAction();
      Log.i("passless", String.format("Intent action = '%s'", action));
      
      if (!NfcAdapter.ACTION_NDEF_DISCOVERED.equals(action)) {
        Log.i(LOGNAME, "onNewIntent: action is not NDEF_DISCOVERED.");
        return false;
      }

      // onResume will handle the intent.
      this.intentHandled = false;

      Log.i(LOGNAME, "onNewIntent: end");
      // TODO: call setintent here? Or does flutter do that for us?
      return true;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
      if (call.method.equals("sendNfc")) {
        // TODO: Do something
        result.notImplemented();
      } else {
        result.notImplemented();
      }
    }
  
    @Override
    public void onListen(Object arguments, EventSink events) {
      // TODO: Add to the eventsink.
      // nfcReceiver = createNfcReceiver(events);
      // registrar
      //     .context()
      //     .registerReceiver(
      //       nfcReceiver, new IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED));
    }
  
    @Override
    public void onCancel(Object arguments) {
      // registrar.context().unregisterReceiver(nfcReceiver);
      // nfcReceiver = null;
    }
  
    // private BroadcastReceiver createNfcReceiver(final EventSink events) {
    //   return new BroadcastReceiver() {
    //     @Override
    //     public void onReceive(Context context, Intent intent) {
    //       Parcelable[] rawMessages =
    //           intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
    //       if (rawMessages != null) {
    //           NdefMessage[] messages = new NdefMessage[rawMessages.length];
    //           for (int i = 0; i < rawMessages.length; i++) {
    //               messages[i] = (NdefMessage) rawMessages[i];
    //           }
              
    //           events.success("{ \"message\": \"Received NFC message\"");
    //       }
    //     }
    //   };
    // }
    
    

    private void setNfcSettings() {
      Log.i("passless", "setNfcSettings: begin");
      nfcAdapter = NfcAdapter.getDefaultAdapter(activity);   
      if (nfcAdapter == null) {
          Log.i("passless", "nfc not supported by device.");
          return;
      }
  
      nfcFilters = new IntentFilter[] { 
        new IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED)
      };
  
      nfcPendingIntent = PendingIntent.getActivity(
        activity, 
        0, 
        new Intent(activity, activity.getClass())
          .addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 
        0);
      
      Log.i("passless", "setNfcSettings: end");
    }
  
    private void handleIntent() {
      Log.i("passless", "handleIntent: begin");
      intentHandled = true;
      Intent intent = activity.getIntent();
  
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