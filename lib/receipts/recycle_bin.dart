import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/receipts/delete_dialog.dart';
import 'package:passless_android/widgets/drawer_menu.dart';
import 'package:passless_android/widgets/menu_button.dart';
import 'package:passless_android/receipts/receipt_listview.dart';
import 'package:passless_android/receipts/search_page.dart';
import 'package:passless_android/models/receipt.dart';

/// The root page of the app.
class RecycleBinPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecycleBinPageState();
}

class _RecycleBinPageState extends State<RecycleBinPage> {
  List<Receipt> _receipts;
  bool _isLoading = true;

  // Use this method as an alternative to initState, 
  // in order to use the repository.
  @override
  void didChangeDependencies() { 
    _initReceipts();

    // Listen for data changes.
    Repository.of(context).listen(() => _initReceipts());
    super.didChangeDependencies();
  }

  _initReceipts() async {
    var receipts = await Repository.of(context).getDeletedReceipts();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    /// Sets the receipts as state and stops the loading process.
    setState(() {
      _receipts = receipts;
      _isLoading = false;
    });
  }

  /// Builds the root page.
  @override
  Widget build(BuildContext context) {
    var loc = PasslessLocalizations.of(context);
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        leading: MenuButton(),
        title: Text(loc.recycleBin),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            tooltip: loc.emptyRecycleBin,
            onPressed: () async {
              bool shouldDelete = await DeleteDialog.show(
                context, 
                _receipts.length);

              if (shouldDelete) {
                await Repository.of(context).deleteBatchPermanently(_receipts);
                Navigator.of(context).pop();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.restore_from_trash),
            tooltip: loc.emptyRecycleBin,
            onPressed: () {
              // TODO: Show a message all receipts will be restored.
              Repository.of(context).undeleteBatch(_receipts);
            },
          )
        ],
      ),
      // Either load or show the list of receipts.
      body: _isLoading ? 
        // TODO: Make sure a receipt in the recycle bin is deleted permanently when deleted.
        const CircularProgressIndicator() : 
        ReceiptListView(_receipts, isSelectable: false,),
    );
  }
}