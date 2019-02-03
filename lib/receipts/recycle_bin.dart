import 'package:flutter/material.dart';
import 'package:passless_android/data/data_provider.dart';
import 'package:passless_android/l10n/passless_localizations.dart';
import 'package:passless_android/receipts/delete_dialog.dart';
import 'package:passless_android/receipts/restore_dialog.dart';
import 'package:passless_android/widgets/drawer_menu.dart';
import 'package:passless_android/widgets/menu_button.dart';
import 'package:passless_android/receipts/receipt_listview.dart';

class RecycleBinPage extends StatelessWidget {
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
              int size = await Repository.of(context).getRecycleBinSize();
              bool shouldDelete = await DeleteDialog.show(
                context, 
                size);

              if (shouldDelete) {
                await Repository.of(context).emptyRecycleBin();
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: ReceiptListView(
        dataFunction: Repository.of(context).getDeletedReceipts,
        selectionActionBuilder: (context, receipts) =>
          <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              tooltip: loc.emptyRecycleBin,
              onPressed: () async {
                bool shouldDelete = await DeleteDialog.show(
                  context, 
                  receipts.length);

                if (shouldDelete) {
                  await Repository.of(context).deleteBatchPermanently(receipts);
                  Navigator.of(context).pop();
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.restore_from_trash),
              tooltip: loc.restoreFromTrash,
              onPressed: () async {
                bool shouldRestore = await RestoreDialog.show(
                  context, 
                  receipts.length);

                if (shouldRestore) {
                  await Repository.of(context).undeleteBatch(receipts);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
      )
    );
  }
}