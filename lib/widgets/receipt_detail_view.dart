import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';

class ReceiptDetailView extends StatelessWidget {
  final Receipt _receipt;
  ReceiptDetailView(this._receipt);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    
    return Card(
        child: _LeftAlignedColumn(
          children: <Widget>[
            _VendorContainer(_receipt.vendor),
            Divider(),
            _ItemsContainer(_receipt.items),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Total", style: theme.textTheme.headline,)
                ),
                Text(
                  _receipt.total.toString(), 
                  style: theme.textTheme.headline,
                ),
              ],
            )
          ],
        )
      );
  }
}

class _VendorContainer extends StatelessWidget {
  final Vendor _vendor;
  _VendorContainer(this._vendor);
  @override
  Widget build(BuildContext context) {
    return _LeftAlignedColumn(
      children: <Widget>[
        Text(_vendor.name), 
        Text(_vendor.address),
        Text(_vendor.telNumber),
      ]
    );
  }
}

class _ItemsContainer extends StatelessWidget {
  final List<Item> _items;
  _ItemsContainer(this._items);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LeftAlignedColumn(
          children: _items.map((i) => Text("${i.quantity}")).toList(),
        ),
        Container(
          padding: EdgeInsets.only(left: 1),
          child: _LeftAlignedColumn(
            children: _items.map((i) {
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
            child:  _LeftAlignedColumn(
              children: _items.map((i) => Text(i.name)).toList(),
            )
          )
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _items.map((i) => Text("${i.subTotal}")).toList(),
        ),
      ]
    );
  }
}

class _LeftAlignedColumn extends Column {
  _LeftAlignedColumn({List<Widget> children})
      : super(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children);
}
