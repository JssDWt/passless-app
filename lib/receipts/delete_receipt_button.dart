import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/models/receipt_state.dart';
import 'package:passless/receipts/delete_dialog.dart';

class DeleteReceiptButton extends StatefulWidget {
  final Receipt receipt;
  DeleteReceiptButton(this.receipt);

  @override
  _DeleteReceiptButtonState createState() => _DeleteReceiptButtonState();
}

class _DeleteReceiptButtonState extends State<DeleteReceiptButton> 
  with SingleTickerProviderStateMixin {
  ReceiptState receiptState = ReceiptState.unknown;

  @override
  void didChangeDependencies() {
    _updateReceiptState();
    super.didChangeDependencies();
  }

  Future<void> _updateReceiptState() async {
    ReceiptState currentState = 
      await Repository.of(context).getReceiptState(widget.receipt);
    if (!mounted) return;
    setState(() {
      receiptState = currentState;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget deleteButton;
    switch (receiptState) {
      case ReceiptState.active:
        deleteButton = FloatingActionButton(
          child: Icon(Icons.delete),
          tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
          onPressed: () async {
            await Repository.of(context).delete(widget.receipt);
            Navigator.of(context).pop(ReceiptState.deleted);
          },
        );
        break;
      case ReceiptState.deleted:
        deleteButton = FloatingActionButton(
          child: Icon(Icons.delete_forever),
          tooltip: PasslessLocalizations.of(context).deletePermanentlyTooltip,
          onPressed: () async {
            bool shouldDelete = await DeleteDialog.show(context, 1);
            if (shouldDelete) {
              await Repository.of(context).deletePermanently(widget.receipt);
              Navigator.of(context).pop(ReceiptState.deletedPermanently);
            }
          },
        );
        break;
      case ReceiptState.unknown:
      default:
        deleteButton = Container(width: 0, height: 0);
        break;
    }

    return Container(
      width: 56.0,
      height: 56.0,
      child: deleteButton
    );
  }
}