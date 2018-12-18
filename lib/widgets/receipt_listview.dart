import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:passless_android/pages/receipt_detail_page.dart';
import 'package:passless_android/widgets/delete_dialog.dart';
import 'package:passless_android/widgets/spinning_hero.dart';

/// Shows a list of receipts.
class ReceiptListView extends StatelessWidget {
  final List<Receipt> receipts;
  ReceiptListView(this.receipts);

  /// Builds the receipt list.
  @override
  Widget build(BuildContext context) => _ReceiptListView(receipts);
}

class _SelectingReceiptListView extends StatefulWidget {
  final List<Receipt> receipts;
  final int primarySelection;
  _SelectingReceiptListView(this.receipts, this.primarySelection);

  @override
  _SelectingReceiptListViewState createState() 
    => _SelectingReceiptListViewState();
}

class _SelectingReceiptListViewState extends State<_SelectingReceiptListView> {
  List<int> _selection;

  @override
  void initState() {
    super.initState();
    this._selection = [widget.primarySelection];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SpinningHero(
          tag: "appBarLeading",
          child: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text("${_selection.length} selected"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool shouldDelete = await DeleteDialog.show(
                context, 
                _selection.length);

              if (shouldDelete) {
                var toDelete = _selection.map((s) => widget.receipts[s]);
                await Repository.of(context).deleteBatch(toDelete);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: _ReceiptListView(
        widget.receipts, 
        selected: _selection,
        selectionChangedCallback: _selectionChangedCallback),
    );
  }

  void _selectionChangedCallback() {
    setState(() {});
  }
}

class _ReceiptListView extends StatefulWidget {
  final List<Receipt> receipts;
  List<int> selected = List<int>();
  void Function() selectionChangedCallback;

  _ReceiptListView(
    this.receipts, 
    {
      List<int> selected,
      this.selectionChangedCallback,
    }) {
    if (selected != null) this.selected = selected;
  }

  @override
  _ReceiptListViewState createState() => _ReceiptListViewState();
}

class _ReceiptListViewState extends State<_ReceiptListView> {
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _isSelecting = widget.selected.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    print('listview build');
    Widget result;
    if (widget.receipts.isEmpty) {
      result = Text("No receipts found.");
    }
    else {
      result = ListView.builder(
        itemCount: widget.receipts.length,
        itemBuilder: (BuildContext context, int index) { 
          Receipt receipt = widget.receipts[index];
          bool isSelected = widget.selected.contains(index);
          return Hero(
            tag: "receipt${receipt.id}",
            child: Card(
              child: ListTile(
                selected: isSelected,
                leading: isSelected ? Icon(Icons.check) : Text(""),
                title: Text(receipt.vendor.name),
                subtitle: Text(
                  PasslessLocalizations.of(context).price(
                    receipt.total, 
                    receipt.currency
                  ),
                  style: Theme.of(context).textTheme.caption,
                ),
                onTap: () {
                  if (_isSelecting) {
                    _onReceiptSelected(index);
                  }
                  else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => 
                          ReceiptDetailPage(receipt, receipt.vendor.name)));
                  }
                },
                onLongPress: () {
                  _onReceiptSelected(index);
                },
              )
            )
          );
        }
      );
    }

    return result;
  }

  void _onReceiptSelected(int index) {
    // If the selected list is currently empty, this will be a new selection.
    // In that case push a new selection page with the same receipts.
    if (widget.selected.isEmpty) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: 
            (context, animation, secondaryAnimation) 
            => _SelectingReceiptListView(widget.receipts, index)
        )
      );
      return;
    }

    // If the receipt was already selected, remove it
    // otherwise add it to selection
    if (!widget.selected.remove(index)) {
      widget.selected.add(index);
    }

    // The last receipt may have been deselected. Then pop to the previous list.
    // NOTE: The only way this function is called, is through selection, so
    // the selection page will be preceded by the non-selected page.
    if (widget.selected.isEmpty) {
      Navigator.of(context).pop();
    }
    else {
      // Make sure to update the changes in the list, and a listening parent.
      setState(() {});
      widget.selectionChangedCallback();
    }
  }
}
