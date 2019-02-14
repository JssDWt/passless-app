import 'package:flutter/material.dart';

class RadioDialog<T> extends StatefulWidget {
  final String title;
  final Map<String, T> options;
  final T initialValue;
  RadioDialog({@required this.title, @required this.options, @required this.initialValue})
    : assert(title != null),
      assert(options != null),
      assert(options.length > 1),
      assert(initialValue != null);

  @override
  RadioDialogState createState() {
    return new RadioDialogState(initialValue);
  }
}

class RadioDialogState<T> extends State<RadioDialog> {
  T value;
  RadioDialogState(this.value)
    : assert(value != null);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.options.keys.map((key) => RadioListTile(
            title: Text(key),
            value: widget.options[key],
            groupValue: value,
            onChanged: (newValue) {
              Navigator.of(context, rootNavigator: true).pop(newValue);
            }
          )).toList(),
        )
      ]
    );
  }
}