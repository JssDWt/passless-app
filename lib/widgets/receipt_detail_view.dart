import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';

class ReceiptDetailView extends StatelessWidget {
  final Receipt receipt;
  ReceiptDetailView(this.receipt);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    
    return Card(
        child: LeftAlignedColumn(
          children: <Widget>[
            VendorContainer(receipt.vendor),
            Divider(),
            ItemsContainer(receipt.items),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Total", style: theme.textTheme.headline,)
                ),
                Text(
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
    return LeftAlignedColumn(
      children: <Widget>[
        Text(vendor.name), 
        Text(vendor.address),
        Text(vendor.telNumber),
      ]
    );
  }
}

class ItemsContainer extends StatelessWidget {
  final List<Item> items;
  ItemsContainer(this.items);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeftAlignedColumn(
          children: items.map((i) => Text("${i.quantity}")).toList(),
        ),
        Container(
          padding: EdgeInsets.only(left: 1),
          child: LeftAlignedColumn(
            children: items.map((i) {
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
            child:  LeftAlignedColumn(
              children: items.map((i) => Text(i.name)).toList(),
            )
          )
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((i) => Text("${i.subTotal}")).toList(),
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
