import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/models/receipt_state.dart';
import 'package:passless/receipts/receipt_detail_page.dart';
import 'package:passless/settings/price_provider.dart';
import 'package:passless/widgets/logo_widget.dart';

class ReceiptListCard extends StatefulWidget {
  final Receipt receipt;
  final void Function(Receipt receipt, bool selected) selectCallback;
  final void Function(Receipt receipt) deleteCallback;
  final bool selectOnTap;
  final bool initiallySelected;
  final bool showSelectionMarker;

  ReceiptListCard(
    this.receipt, 
    { 
      @required this.selectCallback,
      @required this.deleteCallback,
      this.selectOnTap = false,
      this.initiallySelected = false,
      this.showSelectionMarker = true
    });

  @override
  _ReceiptListCardState createState() 
    => _ReceiptListCardState(isSelected: initiallySelected);
}

class _ReceiptListCardState extends State<ReceiptListCard> {
  bool isSelected;
  _ReceiptListCardState({this.isSelected = false});

  void _onReceiptSelected() {
    if (widget.showSelectionMarker) {
      setState(() {
        isSelected = !isSelected;
      });
    }
    
    widget.selectCallback(widget.receipt, isSelected);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var loc = PasslessLocalizations.of(context);
    var pri = PriceProvider.of(context);

    return Hero(
      tag: "receipt${widget.receipt.id}",
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: isSelected ? theme.selectedRowColor : theme.cardColor,
        child: InkWell(
          onTap: () async {
            if (widget.selectOnTap) {
              _onReceiptSelected();
            }
            else {
              ReceiptState state = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => 
                    ReceiptDetailPage(widget.receipt)));
              if (state == ReceiptState.deleted) {
                widget.deleteCallback(widget.receipt);
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
                    LogoWidget(
                      widget.receipt,
                      area: 2700,
                      maxHeight: 65,
                      maxWidth: 150
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              loc.itemCount(widget.receipt.items.length), 
                              style: theme.textTheme.subhead
                            ),
                            Text(
                              loc.datetime(widget.receipt.time), 
                              style: theme.textTheme.subhead
                            )
                          ],
                        ),
                        Expanded(child: Container(),),
                        Text(
                          pri.price(
                            widget.receipt.totalPrice, 
                            widget.receipt.currency
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
}