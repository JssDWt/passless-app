import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/receipts/receipt_list_card.dart';
import 'package:passless/utils/scrolling_listview.dart';
import 'package:passless/widgets/appbar_button.dart';
import 'package:passless/widgets/spinning_hero.dart';

typedef List<Widget> SelectionActionBuilder(
  BuildContext context, 
  List<Receipt> receipts
);

class ReceiptListView extends StatefulWidget {
  final DataFunction dataFunction;
  final SelectionActionBuilder selectionActionBuilder;
  ReceiptListView(
    {
      @required this.dataFunction,
      this.selectionActionBuilder
    }) : assert(dataFunction != null);

  @override
  _ReceiptListViewState createState() => _ReceiptListViewState();
}

class _ReceiptListViewState extends State<ReceiptListView> {
  Key scrollKey = UniqueKey();

  @override 
  void initState() {
    super.initState();

    Repository().listen(() {
      if (!mounted) return;
      setState(() {
        scrollKey = UniqueKey();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollingListView(
      key: scrollKey,
      dataFunction: widget.dataFunction,
      itemBuilder: (context, receipt) 
        => ReceiptListCard(
          receipt,
          isSelected: false,
          deleteCallback: _onReceiptDeleted,
          selectCallback: _onReceiptSelected,
          showSelectionMarker: false,
        ),
      length: 15,
      noContentBuilder: (context) 
        => Text(PasslessLocalizations.of(context).noReceiptsFound),
    );
  }

  void _onReceiptDeleted(Receipt receipt) {
    if (!mounted) return;
    setState(() {});
    var loc = PasslessLocalizations.of(context);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.movedToRecycleBin(1)),
        action: SnackBarAction(
          label: loc.undoButtonLabel,
          onPressed: () async {
            await Repository().undelete(receipt);
            setState(() {});
          },
        )
      )
    );
  }

  Future<void> _onReceiptSelected(Receipt receipt, bool selected) async {
    if (!mounted) return;
    var loc = PasslessLocalizations.of(context);

    var result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: 
          (context, animation, secondaryAnimation) => 
            _SelectingReceiptListView(
              selection: [receipt],
              dataFunction: widget.dataFunction,
              selectionActionBuilder: widget.selectionActionBuilder,
            )
      )
    );

    List<Receipt> deletedReceipts;
    if (result is List<Receipt>) {
      deletedReceipts = result;
    }
    
    if (deletedReceipts != null && deletedReceipts.length > 0) {
      if (!mounted) return;
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.movedToRecycleBin(deletedReceipts.length)),
          action: SnackBarAction(
            label: loc.undoButtonLabel.toUpperCase(),
            onPressed: () async {
              await Repository().undeleteBatch(deletedReceipts);
              if (!mounted) return;
              setState(() {});
            },
          )
        )
      );

      if (!mounted) return;
      setState(() {});
    }
  }
}

class _SelectingReceiptListView extends StatefulWidget {
  final DataFunction dataFunction;
  final List<Receipt> selection;
  final SelectionActionBuilder selectionActionBuilder;
  _SelectingReceiptListView(
    {
      List<Receipt> selection,
      @required this.dataFunction,
      this.selectionActionBuilder
    } 
  ) : this.selection = selection ?? List<Receipt>(),
    assert(dataFunction != null);

  @override
  _SelectingReceiptListViewState createState() 
    => _SelectingReceiptListViewState();
}

class _SelectingReceiptListViewState extends State<_SelectingReceiptListView> {
  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: SpinningHero(
          tag: "appBarLeading",
          child: AppBarButton(
            icon: Icon(Icons.clear),
            tooltip: loc.clearTooltip,
            onPressed: () {
              // Indicate zero receipts deleted.
              Navigator.of(context).pop(0);
            },
          ),
        ),
        title: Text(loc.receiptsSelectedTitle(widget.selection.length)),
        actions: widget.selectionActionBuilder == null
          ? <Widget>[
            AppBarButton(
              icon: Icon(Icons.delete),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: () async {
                await Repository().deleteBatch(widget.selection);
                Navigator.of(context).pop(widget.selection);
              },
            )
          ]
        : widget.selectionActionBuilder(context, widget.selection),
      ),
      body: ScrollingListView(
        dataFunction: widget.dataFunction,
        itemBuilder: (context, receipt) 
          => ReceiptListCard(
            receipt,
            isSelected: widget.selection.map((r) => r.id).contains(receipt.id),
            selectCallback: _onReceiptSelected,
            selectOnTap: true,
          ),
        length: 15,
        noContentBuilder: (context) 
          => Text(PasslessLocalizations.of(context).noReceiptsFound),
      )
    );
  }

  void _onReceiptSelected(Receipt receipt, bool selected) {
    if (selected) {
      setState(() {
        widget.selection.add(receipt);
      });
    }
    else {
      widget.selection.removeWhere((r) => r.id == receipt.id);

      if (widget.selection.isEmpty) {
        Navigator.of(context).pop(0);
      }
      else {
        setState(() {});
      }
    }
  }
}