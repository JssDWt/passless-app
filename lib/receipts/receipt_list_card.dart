import 'package:flutter/material.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/models/receipt_state.dart';
import 'package:passless/receipts/receipt_detail_page.dart';
import 'package:passless/settings/price_provider.dart';
import 'package:passless/widgets/logo_widget.dart';

class ReceiptListCard extends StatelessWidget {
  final Receipt receipt;
  final bool isSelected;
  final void Function(Receipt receipt, bool selected) selectCallback;
  final void Function(Receipt receipt) deleteCallback;
  final bool selectOnTap;
  final bool showSelectionMarker;

  ReceiptListCard(
    this.receipt, 
    {
      @required this.isSelected,
      @required this.selectCallback,
      @required this.deleteCallback,
      this.selectOnTap = false,
      this.showSelectionMarker = true
    });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var loc = PasslessLocalizations.of(context);
    var pri = PriceProvider.of(context);

    return Hero(
      tag: "receipt${receipt.id}",
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: isSelected ? theme.selectedRowColor : theme.cardColor,
        child: InkWell(
          onTap: () async {
            if (selectOnTap) {
              _onReceiptSelected();
            }
            else {
              ReceiptState state = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    ReceiptDetailPage(receipt)));
              if (state == ReceiptState.deleted) {
                deleteCallback(receipt);
              }
            }
          },
          onLongPress: () {
            _onReceiptSelected();
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[ 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LogoWidget(receipt),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              loc.itemCount(receipt.items.length), 
                              style: theme.textTheme.subhead
                            ),
                            Text(
                              loc.datetime(receipt.time), 
                              style: theme.textTheme.subhead
                            )
                          ],
                        ),
                        Expanded(child: Container(),),
                        Text(
                          pri.price(
                            receipt.totalPrice, 
                            receipt.currency
                          ),
                          style: theme.textTheme.title,
                        )
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: isSelected 
                    ? Icon(Icons.check_circle, color: theme.primaryColor) 
                    : Container(),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

  void _onReceiptSelected() {
    selectCallback(receipt, !isSelected);
  }
}