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
      this.deleteCallback,
      this.selectOnTap = false,
      this.showSelectionMarker = true
    }) : assert(isSelected != null),
         assert(selectCallback != null),
         assert(selectOnTap != null),
         assert(showSelectionMarker != null);

  @override
  ReceiptListCardState createState() {
    return new ReceiptListCardState();
  }
}

class ReceiptListCardState extends State<ReceiptListCard> 
  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  static final elevationTween = Tween<double>(begin: 1.0, end: 8.0);
  static final alignmentTween = Tween<double>(begin: -1.0, end: 0.0);

  @override 
  void initState()
  {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100)
    );

    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller)
      ..addListener(() => setState((){}));
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
        elevation: elevationTween.evaluate(animation),
        clipBehavior: Clip.antiAlias,
        color: widget.isSelected ? theme.selectedRowColor : theme.cardColor,
        child: InkWell(
          onTap: () async {
            if (widget.selectOnTap) {
              _onReceiptSelected();
            }
            else {
              await controller.forward();
              if (!mounted) return;
              ReceiptState state = await Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondary) 
                  {
                    animation.addStatusListener((status) {
                      if (status == AnimationStatus.dismissed
                        && mounted)
                      {
                        controller.reverse();
                      }
                    });

                    return ReceiptDetailPage(widget.receipt);
                  }
                )
              );

              if (state == ReceiptState.deleted && widget.deleteCallback != null) {
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
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment(alignmentTween.evaluate(animation), 0),
                          child: LogoWidget(
                            widget.receipt, 
                            alignment: Alignment(alignmentTween.evaluate(animation), 0),
                          ),
                        ),
                      ]
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