import 'dart:async';

import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/receipts/delete_receipt_button.dart';
import 'package:passless/widgets/logo_widget.dart';
import 'package:passless/widgets/overflow_text.dart';
import 'package:passless/settings/price_provider.dart';
import 'package:passless/widgets/semi_divider.dart';
import 'package:rxdart/rxdart.dart';

/// A page that shows receipt details.
class ReceiptDetailPage extends StatelessWidget {
  final Receipt _receipt;
  ReceiptDetailPage(this._receipt);

  @override
  Widget build(BuildContext context) {   
    return SafeArea(
      child: Hero(
        tag: "receipt${_receipt.id}",
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Card(
                elevation: 8,
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BackButton(),
                        Expanded(
                          child: LogoWidget(
                            _receipt, 
                            alignment: Alignment.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DeleteReceiptButton(_receipt),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          _VendorContainer(_receipt),
                          _DateContainer(_receipt),
                          SemiDivider(),
                          _ItemsContainer(_receipt),
                          SemiDivider(),
                          _DiscountContainer(_receipt),
                          _TotalContainer(_receipt),
                          _NoteContainer(_receipt)
                        ],
                      )
                    ),
                  ],
                )
              )
            )
          )
        ),
      ),
    );
  }
}

class _DateContainer  extends StatelessWidget {
  final Receipt _receipt;
  _DateContainer(this._receipt);

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(loc.date(_receipt.time)),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(loc.time(_receipt.time))
        )
      ],
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
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            _receipt.vendor.name, 
            style: Theme.of(context).textTheme.headline
          ),
        ),
        Text(_receipt.vendor.address),//, style: theme.primaryTextTheme.body2),
        Padding(
          padding: EdgeInsets.all(4),
          child: Text(_receipt.vendor.phone),//, style: theme.primaryTextTheme.body2)
        ),
      ]
    );
  }
}

class _ItemsContainer extends StatelessWidget {
  static const double paddingBetweenItems = 4;
  final Receipt _receipt;
  _ItemsContainer(this._receipt);

  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    var pri = PriceProvider.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _receipt.items.map(
            (i) => Padding(
              padding: EdgeInsets.symmetric(vertical: paddingBetweenItems),
              child: Text(loc.quantity(i.quantity, i.unit))
            )
          ).toList(),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 8),
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _receipt.items.map(
                (i) => Padding(
                  padding: EdgeInsets.symmetric(vertical: paddingBetweenItems),
                  child: Text(i.name)
                )
              ).toList(),
            )
          )
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _receipt.items.map(
            (i) => Padding(
              padding: EdgeInsets.symmetric(vertical: paddingBetweenItems),
              child: Text(
                pri.price(i.subtotal, _receipt.currency)
              )
            )
          ).toList(),
        ),
      ]
    );
  }
}

class _DiscountContainer extends StatelessWidget {
  final Receipt _receipt;
  _DiscountContainer(this._receipt);

  @override
  Widget build(BuildContext context) {
    var pri = PriceProvider.of(context);
    var discountLists = _receipt.items.map((i) => i.discounts)
      .where((d) => d != null && d.isNotEmpty).toList();
    if (discountLists.isEmpty) {
      return Container();
    }

    var expanded = discountLists.expand((d) => d).toList();

    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: expanded.map(
                    (d) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(d.name)
                    )
                  ).toList(),
                )
              )
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: expanded.map(
                (d) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    pri.negativePrice(d.deduct, _receipt.currency)
                  )
                )
              ).toList(),
            ),
          ]
        ),
        SemiDivider()
      ],
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
    var pri = PriceProvider.of(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(loc.total, style: theme.textTheme.headline,)
            ),
            Text(
              pri.price(
                _receipt.totalPrice, 
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
              loc.price(
                _receipt.totalPrice.tax, 
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
  bool _isEditing = false;
  String notes;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  Future _initState() async {
    _repository = Repository();
    notes = await _repository.getComments(widget._receipt);
    _controller = TextEditingController(text: notes);
    
    _noteSubject = BehaviorSubject<String>();
    _debounceSubscription = _noteSubject.debounce(Duration(milliseconds: 400))
      .listen((c) => _repository?.updateComments(widget._receipt, c));
    _controller.addListener(() => _noteSubject?.add(_controller.text));

    if (!mounted) return;
    setState(() {});
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
      noteField = const Text("");
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
      noteField = OverflowText(notes, maxLines: 3);

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

