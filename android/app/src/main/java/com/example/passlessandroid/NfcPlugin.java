package com.example.passlessandroid;

import android.os.Parcelable;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.BroadcastReceiver;
import android.nfc.NfcAdapter;
import android.nfc.NdefMessage;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class NfcPlugin implements MethodCallHandler, StreamHandler {
    static final String STREAM = "flutter.passless.com/nfc-stream";
    static final String CHANNEL = "flutter.passless.com/nfc-channel";
  
    public static void registerWith(PluginRegistry.Registrar registrar) {
      final MethodChannel methodChannel =
          new MethodChannel(registrar.messenger(), CHANNEL);
      final EventChannel eventChannel =
          new EventChannel(registrar.messenger(), STREAM);
      final NfcPlugin instance = new NfcPlugin(registrar);
      eventChannel.setStreamHandler(instance);
      methodChannel.setMethodCallHandler(instance);
    }
  
    NfcPlugin(PluginRegistry.Registrar registrar) {
      this.registrar = registrar;
    }
  
    private final PluginRegistry.Registrar registrar;
    private BroadcastReceiver nfcReceiver;
  
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
      nfcReceiver = createNfcReceiver(events);
      registrar
          .context()
          .registerReceiver(
            nfcReceiver, new IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED));
    }
  
    @Override
    public void onCancel(Object arguments) {
      registrar.context().unregisterReceiver(nfcReceiver);
      nfcReceiver = null;
    }
  
    private BroadcastReceiver createNfcReceiver(final EventSink events) {
      return new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
          Parcelable[] rawMessages =
              intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
          if (rawMessages != null) {
              NdefMessage[] messages = new NdefMessage[rawMessages.length];
              for (int i = 0; i < rawMessages.length; i++) {
                  messages[i] = (NdefMessage) rawMessages[i];
              }
              
              events.success("{ \"message\": \"Received NFC message\"");
          }
        }
      };
    }
  }