import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';

class ReceiptDetailView extends StatelessWidget {
  final Receipt _receipt;
  ReceiptDetailView(this._receipt);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "receipt${_receipt.id}",
      child: Card(
        child: Column(
          children: <Widget>[
            _VendorContainer(_receipt),
            SemiDivider(),
            _ItemsContainer(_receipt),
            SemiDivider(),
            _TotalContainer(_receipt),
          ],
        )
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _receipt.items.map((i) => Text("${i.quantity}")).toList(),
        ),
        Container(
          padding: EdgeInsets.only(left: 1),
          child: Column(
            children: _receipt.items.map((i) {
              String text;
              if (i.unit.toLowerCase() == "pc") {
                text = "";
              }
              else {
                text = i.unit;
              }

              return Text(text);
            }).toList(),
          )
        ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _receipt.items.map((i) => Text("${i.subTotal}")).toList(),
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

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text("Total", style: theme.textTheme.headline,)
            ),
            Text(
              "${_receipt.currency} ${_receipt.total}", 
              style: theme.textTheme.headline,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text("Tax")
            ),
            Text("${_receipt.currency} ${_receipt.tax}"),
          ],
        ),
      ]
      
    );
  }

}
class SemiDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.symmetric(horizontal: 8.0),
      child: Divider()
    );
  }
}