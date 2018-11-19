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
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new VendorContainer(receipt.vendor),
            new Divider(),
            new Container(

              child: new Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(receipt.time.toLocal().toString()),
                  new Text("${receipt.currency} ${receipt.total}"),
                ]
              )
            ),
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
    ThemeData theme = Theme.of(context);
    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text("Vendor", style: theme.textTheme.headline,),
        new Text(vendor.name),
        new Text(vendor.address)
      ]
    );
  }

}