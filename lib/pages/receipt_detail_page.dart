import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:passless_android/widgets/delete_dialog.dart';
import 'package:passless_android/widgets/semi_divider.dart';
import 'package:rxdart/rxdart.dart';

/// A page that shows receipt details.
class ReceiptDetailPage extends StatelessWidget {
  final Receipt _receipt;
  final String _title;
  ReceiptDetailPage(this._receipt, this._title);

  @override
  Widget build(BuildContext context) {   
    return Hero(
      tag: "receipt${_receipt.id}",
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete), 
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: () async {
                bool shouldDelete = await DeleteDialog.show(context, 1);

                if (shouldDelete) {
                  await Repository.of(context).delete(_receipt);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      _VendorContainer(_receipt),
                      SemiDivider(),
                      _ItemsContainer(_receipt),
                      SemiDivider(),
                      _TotalContainer(_receipt),
                      _NoteContainer(_receipt)
                    ],
                  )
                )
              )
            )
          )
        ),
      )
    );
  }
}

class _VendorContainer extends StatelessWidget {
  final Receipt _receipt;
  _VendorContainer(this._receipt);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(_receipt.vendor.name),
        Text(_receipt.vendor.address),
        Text(_receipt.vendor.telNumber),
      ]
    );
  }
}

class _ItemsContainer extends StatelessWidget {
  final Receipt _receipt;
  _ItemsContainer(this._receipt);

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _receipt.items.map(
            (i) => Text(loc.quantity(i.quantity, i.unit))
          ).toList(),
        ),
        // Container(
        //   padding: EdgeInsets.only(left: 1),
        //   child: Column(
        //     children: _receipt.items.map((i) {
        //       String text;
        //       if (i.unit.toLowerCase() == "pc") {
        //         text = "";
        //       }
        //       else {
        //         text = i.unit;
        //       }

        //       return Text(text);
        //     }).toList(),
        //   )
        // ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 8),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _receipt.items.map((i) => Text(i.name)).toList(),
            )
          )
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _receipt.items.map(
            (i) => Text(
              loc.price(i.subTotal, i.currency)
            )
          ).toList(),
        ),
      ]
    );
  }
}

class _TotalContainer extends StatelessWidget {
  final Receipt _receipt;
  _TotalContainer(this._receipt);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var loc = PasslessLocalizations.of(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(loc.total, style: theme.textTheme.headline,)
            ),
            Text(
              PasslessLocalizations.of(context).price(
                _receipt.total, 
                _receipt.currency
              ), 
              style: theme.textTheme.headline,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(loc.tax)
            ),
            Text(
              PasslessLocalizations.of(context).price(
                _receipt.tax, 
                _receipt.currency
              )
            ),
          ],
        ),
      ]
    );
  }
}

class _NoteContainer extends StatefulWidget {
  final Receipt _receipt;
  _NoteContainer(this._receipt);
  @override
  _NoteContainerState createState() => _NoteContainerState();
}

class _NoteContainerState extends State<_NoteContainer> {
  Repository _repository;
  BehaviorSubject<String> _noteSubject;
  TextEditingController _controller;
  StreamSubscription<String> _debounceSubscription;
  bool _isLoading = true;
  bool _isEditing = false;
  String notes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initState();
  }

  Future _initState() async {
    _repository = Repository.of(context);
    notes = await _repository.getComments(widget._receipt);
    _controller = TextEditingController(text: notes);
    
    _noteSubject = BehaviorSubject<String>();
    _debounceSubscription = _noteSubject.debounce(Duration(milliseconds: 400))
      .listen((c) => _repository?.updateComments(widget._receipt, c));
    _controller.addListener(() => _noteSubject?.add(_controller.text));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
      _controller = null;
    }

    if (_debounceSubscription != null) {
      _debounceSubscription.cancel();
      _debounceSubscription = null;
    }

    if (_noteSubject != null) {
      _noteSubject.close();
      _noteSubject = null;
    }

    _repository = null;
  }

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);

    List<Widget> actions;
    Widget noteField;
    if (_isEditing) {
      noteField = TextField(
        autofocus: true,
        controller: _controller,
        keyboardType: TextInputType.multiline,
        maxLines: 20,
      );
      actions = [
        IconButton(
          icon: Icon(Icons.save),
          tooltip: loc.saveNotesTooltip,
          onPressed: () {
            // NOTE: The comments are saved automagically.
            setState(() {
              notes = _controller.text;
              _isEditing = false;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.clear),
          tooltip: loc.cancelEditTooltip,
          onPressed: () {
            setState(() {
              _controller.text = notes;
              _isEditing = false;
            });
          },
        ),
      ];
    }
    else if (notes == null || notes.isEmpty) {
      noteField = Text("");
      actions = [
        IconButton(
          icon: Icon(Icons.note_add,),
          tooltip: loc.addNotesTooltip,
          onPressed: () {
            setState(() => _isEditing = true);
          },
        )
      ];
    }
    else {
      noteField = Text(notes, softWrap: true);
      actions = [
        IconButton(
          icon: Icon(Icons.edit),
          tooltip: loc.editNotesTooltip,
          onPressed: () {
            setState(() => _isEditing = true);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: loc.deleteNotesTooltip,
          onPressed: () {
            setState(() {
              _controller.clear();
              notes = null;    
              _isEditing = false; 
            });
          },
        ),
      ];
    }

    return Column(
      children: <Widget>[
        SemiDivider(),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(loc.notes, style: Theme.of(context).textTheme.subhead),
            ),
            Row(
              children: actions,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: noteField
            ),
          ],
        )
      ],
    );
  }
}

