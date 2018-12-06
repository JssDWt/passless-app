import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:passless_android/models/receipt.dart';

class DataProvider extends StatefulWidget {
  final Widget child;
  DataProvider({this.child});

  @override
  State<StatefulWidget> createState() => _DataProviderState();
}

class _DataProviderState extends State<DataProvider> {
  final Repository _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return _DataProvider(_repository, child: widget.child);
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }
}

class _DataProvider extends InheritedWidget {
  final Repository repository;
  _DataProvider(this.repository, { Key key, Widget child }) 
    : super(key: key, child: child );

  @override
  bool updateShouldNotify(_DataProvider oldWidget) => false;
}

// TODO: Either use a document database, import json1 extension or normalize the
// data structure

/// A helper for accessing receipt data.
class Repository {
  static const String RECEIPT_TABLE = "receipts";

  static Repository of(BuildContext context) {
    final _DataProvider provider = 
      context.inheritFromWidgetOfExactType(_DataProvider);
    return provider.repository;
  }

  Database _db;

  /// Returns the initialized singleton database instance.
  Future<Database> get db async {
    if (_db == null) _db = await initDb();
    return _db;
  }

  var _dataChanged = StreamController<Null>.broadcast();
  
  void notifyDataChanged() {
    _dataChanged.add(null);
  }

  void listen(void Function() callback) {
    _dataChanged.stream.listen((l) => callback());
  }

  Future<dynamic> close() async {
    await _db.close();
    _db = null;
  }

  /// Initializes a new database instance.
  /// 
  /// The database is created on the file system (passless.db) 
  /// if it does not yet exist.
  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "passless.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  /// Creates the initial setup of the database.
  void _onCreate(Database db, int version) async {
    
    // When creating the db, create the receipts table
    await db.execute(
      "CREATE TABLE Receipts(id INTEGER PRIMARY KEY, receipt TEXT)");

    await db.rawInsert(
      "INSERT INTO Receipts (receipt) VALUES (?)",
      ["""{
      "time": "2018-10-28T10:27:00+01:00",
      "currency": "EUR",
      "total": 22.58,
      "tax": 1.35,
      "items": [
          {
              "name": "Bananen",
              "brand": "AH Biologisch",
              "quantity": 1.00,
              "unit": "KG",
              "unitPrice": 2.59,
              "currency": "EUR",
              "subTotal": 2.59,
              "tax": 0.1554
          },
          {
              "name": "Baby dry pants maat 5",
              "brand": "Pampers",
              "quantity": 3,
              "unit": "pc",
              "unitPrice": 9.99,
              "currency": "EUR",
              "discounts": [{
                  "name": "2 + 1 gratis",
                  "original": 29.97,
                  "deduct": 9.99 
              }],
              "subTotal": 19.98,
              "tax": 1.1988
          }
      ],
      "payments": [
          {
              "method": "cash",
              "currency": "EUR",
              "amount": 20.00,
              "meta": {
                  "tendered": 20.00,
                  "change": 0.00
              }
          },
          {
              "method": "card",
              "currency": "EUR",
              "amount": 2.58,
              "meta": {
                  "type": "Maestro",
                  "cardNumber": "1234 5678 1234 5678",
                  "expiration": "2023-10-28T00:00:00Z"
              }
          }
      ],
      "loyalties": [
          {
            "points": 412
          }
      ],
      "vendor": {
          "name": "Albert Heijn 1376",
          "address": "Amsterdamsestraatweg 367A, 3551CK, Utrecht",
          "telNumber": "030-2420200",
          "vatNumber": "NL002230884b01",
          "kvkNumber": "35012085",
          "web": "https://www.ah.nl/winkel/1376",
          "meta": {
            "operator": "Henny van de Hoek"
          }
      }
    }"""]);
    await db.rawInsert(
      "INSERT INTO Receipts (receipt) VALUES (?)",
      ["""{
      "time": "2017-10-28T10:27:00+01:00",
      "currency": "EUR",
      "total": 10,
      "tax": 1,
      "items": [
          {
              "name": "Kaars",
              "brand": "Honeybush",
              "quantity": 2.00,
              "unit": "pc",
              "unitPrice": 2.50,
              "currency": "EUR",
              "subTotal": 5,
              "tax": 0.5
          },
          {
              "name": "Aansteker",
              "brand": "Jumbo",
              "quantity": 10,
              "unit": "pc",
              "unitPrice": 1,
              "currency": "EUR",
              "discounts": [{
                  "name": "2e gratis",
                  "original": 10,
                  "deduct": 5 
              }],
              "subTotal": 5,
              "tax": 1
          }
      ],
      "payments": [
          {
              "method": "card",
              "currency": "EUR",
              "amount": 10,
              "meta": {
                  "type": "Maestro",
                  "cardNumber": "1234 5678 1234 5678",
                  "expiration": "2023-10-28T00:00:00Z"
              }
          }
      ],
      "loyalties": [
          {
            "points": 5
          }
      ],
      "vendor": {
          "name": "Jumbo Utrecht Merelstraat",
          "address": "Merelstraat 46, 3514 CN Utrecht",
          "telNumber": "030-6630160",
          "vatNumber": "NL00123012303",
          "kvkNumber": "87234821",
          "web": "https://www.jumbo.com/winkels/jumbo-utrecht-merelstraat/",
          "meta": {
            "operator": "Pietje Dirk"
          }
      }
    }"""]);
    await db.rawInsert(
      "INSERT INTO Receipts (receipt) VALUES (?)",
      ["""{
      "time": "2018-09-11T11:27:00+01:00",
      "currency": "EUR",
      "total": 4.59,
      "tax": 0.77,
      "items": [
          {
              "name": "Prrrikweg",
              "brand": "A. Vogel",
              "quantity": 1.00,
              "unit": "pc",
              "unitPrice": 4.59,
              "currency": "EUR",
              "subTotal": 4.59,
              "tax": 0.77
          }
      ],
      "payments": [
          {
              "method": "card",
              "currency": "EUR",
              "amount": 4.59,
              "meta": {
                  "type": "Maestro",
                  "cardNumber": "1234 5678 1234 5678",
                  "expiration": "2023-10-28T00:00:00Z"
              }
          }
      ],
      "loyalties": [],
      "vendor": {
          "name": "Kruidvat",
          "address": "Amsterdamsestraatweg 391, 3551 CL Utrecht",
          "telNumber": "0318-798000",
          "vatNumber": "NL001229847123",
          "kvkNumber": "98375892",
          "web": "https://www.kruidvat.nl/winkel/DROGISTERIJ%20KRUIDVAT%20850",
          "meta": {
            "operator": "Suraya Vos"
          }
      }
    }"""]);
    print("Created tables");
  }

  /// Retrieves all receipts.
  Future<List<Receipt>> getReceipts() async {
    var dbClient = await db;
    List<Map> list = 
      await dbClient.rawQuery("SELECT id, receipt FROM receipts");
    return list.map(_fromMap).toList();
  }

  /// Stores the specified receipt.
  Future<Receipt> saveReceipt(Receipt receipt) async {
    // TODO: Check for doubles
    var dbClient = await db;
    Receipt result;
    await dbClient.transaction((txn) async {
      int id = await txn.insert(
        RECEIPT_TABLE, 
        {"receipt": json.encode(receipt.toJson())});
      var inserted = await txn.query(
        RECEIPT_TABLE, 
        where: "id = ?", 
        whereArgs: [id]);
      result = _fromMap(inserted.first);
    });

    if (result != null) notifyDataChanged();
    return result;
  }

  Future<List<Receipt>> search(String search) async {
    search = search.toLowerCase();
    List<Receipt> receipts = await getReceipts();
    receipts.retainWhere((receipt) => 
      receipt.vendor.name.toLowerCase().contains(search)
      || receipt.items.any((item) => item.name.toLowerCase().contains(search)));
 
    return receipts;
  }

  Future<bool> delete(Receipt receipt) async {
    var dbClient = await db;
    int deleted = await dbClient.delete(
      RECEIPT_TABLE, 
      where: "id = ?", 
      whereArgs: [receipt.id]);
    bool result = false;
    if (deleted > 0) {
      result = true;
      notifyDataChanged();
      if (deleted > 1) {
        print("More than one record was deleted. Ouch.");
      }
    }

    return result;
  }

  Future<bool> deleteBatch(Iterable<Receipt> receipts) async {
    int count = receipts.length;
    if (count == 0) {
      return false;
    }

    if (count == 1) {
      return delete(receipts.first);
    }

    String questionMarks = receipts.map((r) => "?").join(",");
    var dbClient = await db;
    
    int deleted = await dbClient.rawDelete(
      "DELETE FROM $RECEIPT_TABLE WHERE id in ($questionMarks)", 
      receipts.map((r) => r.id).toList());

    bool result = false;
    if (deleted == count) {
      result = true;
      notifyDataChanged();
    }
    else if (deleted == 0) {
      // Do nothing
    }
    else {
      print("Expected to delete $count, but deleted $deleted");
      result = false;
      notifyDataChanged();
    }

    return result;
  }

  Receipt _fromMap(Map map) {
    var receiptJson = json.decode(map["receipt"]);
    Receipt receipt = Receipt.fromJson(receiptJson);
    receipt.id = map["id"] as int;
    return receipt;
  }
}