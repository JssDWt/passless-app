import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';

/// Represents the global receipt state.
class ReceiptInheritedWidget extends InheritedWidget {
  final List<Receipt> receipts;
  final bool isLoading;

  const ReceiptInheritedWidget(this.receipts, this.isLoading, child)
      : super(child: child);

  /// Defines the global state context.
  static ReceiptInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ReceiptInheritedWidget);
  }

  /// Determines whether state has changed and listeners should be notified.
  @override
  bool updateShouldNotify(ReceiptInheritedWidget oldWidget) =>
      receipts != oldWidget.receipts || isLoading != oldWidget.isLoading;
}