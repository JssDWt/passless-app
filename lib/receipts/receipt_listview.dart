import 'package:flutter/material.dart';
import 'package:passless/data/data_provider.dart';
import 'package:passless/l10n/passless_localizations.dart';
import 'package:passless/models/receipt.dart';
import 'package:passless/receipts/receipt_list_card.dart';
import 'package:passless/utils/scrolling_listview.dart';
import 'package:passless/widgets/spinning_hero.dart';

typedef List<Widget> SelectionActionBuilder(
  BuildContext context, 
  List<Receipt> receipts
);

class ReceiptListView extends StatefulWidget {
  final DataFunction dataFunction;
  final List<Receipt> initialData;
  final SelectionActionBuilder selectionActionBuilder;
  ReceiptListView(
    {
      List<Receipt> initialData,
      @required this.dataFunction,
      this.selectionActionBuilder
    }) : this.initialData = initialData ?? List<Receipt>();

  @override
  _ReceiptListViewState createState() => _ReceiptListViewState();
}

class _ReceiptListViewState extends State<ReceiptListView> {
  Key scrollKey = UniqueKey();

  @override 
  void didChangeDependencies() {
    super.didChangeDependencies();

    // TODO: Make sure the same amount of receipts is loaded.
    Repository.of(context).listen(() {
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
    setState(() {});
    var loc = PasslessLocalizations.of(context);

    // TODO: Add UNDO button.
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.movedToRecycleBin(1))
      )
    );
  }

  Future<void> _onReceiptSelected(Receipt receipt, bool selected) async {
    var loc = PasslessLocalizations.of(context);

    var result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: 
          (context, animation, secondaryAnimation) => 
            // TODO: Fill initialData here.
            _SelectingReceiptListView(
              selection: [receipt],
              dataFunction: widget.dataFunction,
              selectionActionBuilder: widget.selectionActionBuilder,
            )
      )
    );

    int deleteCount = 0;
    if (result is int) {
      deleteCount = result;
    }
    
    if (deleteCount > 0) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.movedToRecycleBin(deleteCount))
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
  ) : this.selection = selection ?? List<Receipt>();

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
          child: IconButton(
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
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: () async {
                await Repository.of(context).deleteBatch(widget.selection);
                Navigator.of(context).pop(widget.selection.length);
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
            deleteCallback: null,
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