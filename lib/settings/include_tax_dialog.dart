import 'package:flutter/material.dart';
import 'package:passless/l10n/passless_localizations.dart';

class IncludeTaxDialog extends StatefulWidget {
  final bool includeTax;
  IncludeTaxDialog(this.includeTax)
    : assert(includeTax != null);

  @override
  _IncludeTaxDialogState createState() => _IncludeTaxDialogState(includeTax);
}

class _IncludeTaxDialogState extends State<IncludeTaxDialog> {
  final bool _initialIncludeTax;
  bool _includeTax;

  _IncludeTaxDialogState(this._initialIncludeTax)
    : assert (_initialIncludeTax != null) 
  {
    this._includeTax = this._initialIncludeTax;
  }

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    return SimpleDialog(
      title: Text(loc.vatSettings),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RadioListTile(
              title: Text(loc.includeTax),
              value: true,
              groupValue: _includeTax,
              onChanged: (newValue) {
                setState(() {
                  _includeTax = newValue;
                });
              }
            ),
            RadioListTile(
              title: Text(loc.excludeTax),
              value: false,
              groupValue: _includeTax,
              onChanged: (newValue) {
                setState(() {
                  _includeTax = newValue;
                });
              }
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text(loc.readyButtonLabel),
              onPressed: () => Navigator.of(context, rootNavigator: true)
                .pop(_includeTax),
            )
          ],
        )
      ],
    );
  }
}