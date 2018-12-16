import 'package:flutter/material.dart';
import 'package:nfc/nfc.dart';

class NfcProvider extends InheritedWidget {
  final Nfc _nfc = Nfc();

  NfcProvider({ Key key, Widget child })
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(NfcProvider oldWidget) =>
    _nfc.nfcEnabled != oldWidget._nfc.nfcEnabled 
      || _nfc.nfcAvailable != oldWidget._nfc.nfcAvailable;

  static Nfc of(BuildContext context) {
    final NfcProvider provider = 
      context.inheritFromWidgetOfExactType(NfcProvider);
    return provider._nfc;
  }
}