import 'dart:io';
import 'package:passless_android/widgets/receipt_inherited.dart';
import 'package:passless_android/receipt.dart';
import 'package:flutter/material.dart';
import 'package:passless_android/pages/receipt_detail.dart';

class ReceiptListView extends StatelessWidget {
  //final List<MaterialColor> _colors = Colors.primaries;
  @override
  Widget build(BuildContext context) {
    final rootIW = ReceiptInheritedWidget.of(context);
    List<Receipt> receipts = rootIW.receipts;
    return new ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, int index) {
        var receipt = receipts[index];
        //final MaterialColor color = _colors[index % _colors.length];

        return new ListTile(
          dense: false,
          // leading: new Hero(
          //   child: avatar(artFile, s.title, color),
          //   tag: s.title,
          // ),
          title: new Text(receipt.vendor.name),
          subtitle: new Text(
            "${receipt.currency} ${receipt.total}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ReceiptDetail(receipts, receipt)));
          },
        );
      },
    );
  }
}