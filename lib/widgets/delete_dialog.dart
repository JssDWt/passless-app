import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final int deleteCount;
  DeleteDialog(this.deleteCount) :
    assert(deleteCount > 0, "deleteCount should be greater than 0.");

  @override
  Widget build(BuildContext context) {
    final String extraS = deleteCount > 1 ? "s" : "";
    return AlertDialog(
      title: Text("Delete $deleteCount receipt$extraS?"),
      content: Text("You will not be able to recover the receipt$extraS later."),
      actions: <Widget>[
        FlatButton(
          child: const Text("CANCEL"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(false);
          },
        ),
        FlatButton(
          child: const Text("DELETE"),
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