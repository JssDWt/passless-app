import 'package:flutter/material.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/models/receipt_state.dart';
import 'package:passless/receipts/receipt_detail_page.dart';
import 'package:passless/settings/price_provider.dart';
import 'package:passless/widgets/logo_widget.dart';

class ReceiptListCard extends StatefulWidget {
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
  ReceiptListCardState createState() {
    return new ReceiptListCardState();
  }
}

class ReceiptListCardState extends State<ReceiptListCard> 
  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override 
  void initState()
  {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200)
    );

    animation = Tween<double>(begin: 1.0, end: 8.0).animate(controller)
      ..addListener(() {
        setState((){});
      });
  }

  @override
  void dispose()
  {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var loc = PasslessLocalizations.of(context);
    var pri = PriceProvider.of(context);

    return Hero(
      tag: "receipt${widget.receipt.id}",
      child: Card(
        elevation: animation.value,
        clipBehavior: Clip.antiAlias,
        color: widget.isSelected ? theme.selectedRowColor : theme.cardColor,
        child: InkWell(
          onTap: () async {
            if (widget.selectOnTap) {
              _onReceiptSelected();
            }
            else {
              controller.forward().then((f) async {
                ReceiptState state = await Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondary) => 
                    ReceiptDetailPage(widget.receipt)
                );
                controller.reverse();

              if (state == ReceiptState.deleted) {
                widget.deleteCallback(widget.receipt);
              }
              });
              
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
                      alignment: Alignment.centerLeft,
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
                  child: widget.isSelected 
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
    widget.selectCallback(widget.receipt, !widget.isSelected);
  }
}