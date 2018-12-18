import 'package:flutter/material.dart';
import 'package:passless_android/l10n/passless_localizations.dart';

class DeleteDialog extends StatelessWidget {
  final int deleteCount;
  DeleteDialog(this.deleteCount) :
    assert(deleteCount > 0, "deleteCount should be greater than 0.");

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    var matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.deleteReceiptsDialogTitle(deleteCount)),
      content: Text(loc.deleteReceiptsDialogTitle(deleteCount)),
      actions: <Widget>[
        FlatButton(
          child: Text(matLoc.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        ),
        FlatButton(
          child: Text(matLoc.deleteButtonTooltip.toUpperCase()),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(true);
          },
        ),
      ],
    );
  }

  static Future<bool> show(BuildContext context, int deleteCount) {
    return showDialog(
      context: context, 
      builder: (context) => DeleteDialog(deleteCount)
    );
  }
}