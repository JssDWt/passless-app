import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';

class ReceiptDetailView extends StatelessWidget {
  final Receipt receipt;
  ReceiptDetailView(this.receipt);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    
    return new Card(
        child: new LeftAlignedColumn(
          children: <Widget>[
            new VendorContainer(receipt.vendor),
            new Divider(),
            new ItemsContainer(receipt.items),
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text("Total", style: theme.textTheme.headline,)
                ),
                new Text(
                  receipt.total.toString(), 
                  style: theme.textTheme.headline,
                ),
              ],
            )
          ],
        )
      );
  }
}

class VendorContainer extends StatelessWidget {
  final Vendor vendor;
  VendorContainer(this.vendor);
  @override
  Widget build(BuildContext context) {
    return new LeftAlignedColumn(
      children: <Widget>[
        new Text(vendor.name), 
        new Text(vendor.address),
        new Text(vendor.telNumber),
      ]
    );
  }
}

class ItemsContainer extends StatelessWidget {
  final List<Item> items;
  ItemsContainer(this.items);

  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new LeftAlignedColumn(
          children: items.map((i) => new Text("${i.quantity}")).toList(),
        ),
        new Container(
          padding: EdgeInsets.only(left: 1),
          child: new LeftAlignedColumn(
            children: items.map((i) {
              String text;
              if (i.unit.toLowerCase() == "pc") {
                text = "";
              }
              else {
                text = i.unit;
              }

              return new Text(text);
            }).toList(),
          )
        ),
        new Expanded(
          child: new Container(
            padding: EdgeInsets.only(left: 8),
            child:  new LeftAlignedColumn(
              children: items.map((i) => new Text(i.name)).toList(),
            )
          )
        ),
        new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((i) => new Text("${i.subTotal}")).toList(),
        ),
      ]
    );
  }
}

class LeftAlignedColumn extends Column {
  LeftAlignedColumn({List<Widget> children})
      : super(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children);
}
