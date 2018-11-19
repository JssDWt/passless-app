import 'package:flutter/material.dart';
import 'package:passless_android/models/receipt.dart';

/// A page that shows receipt details.
class ReceiptDetail extends StatefulWidget {
  final Receipt _receipt;

  ReceiptDetail(this._receipt);

  @override
  _ReceiptDetailState createState() => new _ReceiptDetailState();
}

/// The state of a single receipt page.
class _ReceiptDetailState extends State<ReceiptDetail> {
  Receipt receipt;

  @override
  initState() {
    super.initState();
    initReceipt();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Set the receipt state when it is initialized.
  initReceipt() async {
    setState(() {
      receipt = widget._receipt;
    });
  }

  /// Build the receipt view.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(receipt.vendor.name),
        centerTitle: true,
      ),
      body: new Card(
        child: new LeftAlignedColumn(
          children: <Widget>[
            new VendorContainer(receipt.vendor),
            new Divider(),
            new ItemsContainer(receipt.items),
          ],
        )
      ),
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
        new Text(vendor.address)
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
