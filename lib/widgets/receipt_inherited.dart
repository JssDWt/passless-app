import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';

class ReceiptInheritedWidget extends InheritedWidget {
  final List<Receipt> receipts;
  final bool isLoading;

  const ReceiptInheritedWidget(this.receipts, this.isLoading, child)
      : super(child: child);

  static ReceiptInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ReceiptInheritedWidget);
  }

  @override
  bool updateShouldNotify(ReceiptInheritedWidget oldWidget) =>
      receipts != oldWidget.receipts || isLoading != oldWidget.isLoading;
}