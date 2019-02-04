import 'package:flutter/material.dart';
import 'package:passless/l10n/passless_localizations.dart';

class RestoreDialog extends StatelessWidget {
  final int restoreCount;
  RestoreDialog(this.restoreCount) :
    assert(restoreCount > 0, "restoreCount should be greater than 0.");

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    var matLoc = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(loc.restoreReceiptsDialogTitle(restoreCount)),
      content: Text(loc.restoreReceiptsDialogMessage(restoreCount)),
      actions: <Widget>[
        FlatButton(
          child: Text(matLoc.cancelButtonLabel),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        ),
        FlatButton(
          child: Text(loc.restoreButtonTooltip.toUpperCase()),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(true);
          },
        ),
      ],
    );
  }

  static Future<bool> show(BuildContext context, int restoreCount) {
    return showDialog(
      context: context, 
      builder: (context) => RestoreDialog(restoreCount)
    );
  }
}