import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passless/data/data_exception.dart';
import 'package:passless/data/invalid_receipt_exception.dart';
import 'package:passless/models/preferences.dart';
import 'package:passless/models/receipt_state.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


import 'package:passless/models/receipt.dart';

// TODO: Either use a document database, import json1 extension or normalize the
// data structure

/// A helper for accessing receipt data.
class Repository {
  static const String RECEIPT_TABLE = "receipts";
  static const String RECEIPT_VENDOR_TABLE = "receipt_vendors";
  static const String ACTIVE_RECEIPT_TABLE = "active_receipts";
  static const String RECYCLE_BIN_TABLE = "recycle_bin";
  static const String NOTE_TABLE = "notes";
  static const String PREFERENCE_TABLE = "preferences";

  static final Repository _repo = Repository._internal();
  Database _db;

  factory Repository() {
    return _repo;
  }
  
  Repository._internal();

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
    var theDb = await openDatabase(
      path, 
      version: 1, 
      onConfigure: _onConfigure, 
      onCreate: _onCreate
    );
    return theDb;
  }

  void _onConfigure(Database db) {
    db.execute("PRAGMA foreign_keys = ON");
  }

  /// Creates the initial setup of the database.
  void _onCreate(Database db, int version) async {
    await db.execute(
      """CREATE TABLE $PREFERENCE_TABLE(
        id INTEGER PRIMARY KEY NOT NULL, 
        includeTax INTEGER NOT NULL)""");
    
    await db.execute(
      """CREATE TABLE $RECEIPT_TABLE(
        id INTEGER PRIMARY KEY NOT NULL, 
        receipt TEXT NOT NULL)""");

    await db.execute(
      """CREATE TABLE $ACTIVE_RECEIPT_TABLE(
        id INTEGER PRIMARY KEY NOT NULL, 
        receipt_id INTEGER NOT NULL,
        CONSTRAINT fk_receipts
          FOREIGN KEY (receipt_id)
          REFERENCES $RECEIPT_TABLE(id)
          ON DELETE CASCADE)""");
    
    await db.execute(
      """CREATE UNIQUE INDEX idx_active_receipts_receipt
          ON $ACTIVE_RECEIPT_TABLE (receipt_id DESC)""");
    
    await db.execute(
      """CREATE TRIGGER make_active_receipt AFTER INSERT
          ON $RECEIPT_TABLE
          BEGIN
          INSERT INTO $ACTIVE_RECEIPT_TABLE(receipt_id) VALUES (new.id);
          END"""
    );

    await db.execute(
      """CREATE TABLE $RECYCLE_BIN_TABLE(
        id INTEGER PRIMARY KEY NOT NULL, 
        receipt_id INTEGER NOT NULL,
        CONSTRAINT fk_receipts
          FOREIGN KEY (receipt_id)
          REFERENCES $RECEIPT_TABLE(id)
          ON DELETE CASCADE)""");
    
    await db.execute(
      """CREATE UNIQUE INDEX idx_recycle_bin_receipt
          ON $RECYCLE_BIN_TABLE (receipt_id DESC)""");

    await db.execute(
      """CREATE TABLE $NOTE_TABLE(
        id INTEGER PRIMARY KEY NOT NULL, 
        receipt_id INTEGER NOT NULL,
        note TEXT NULL, 
        date REAL NOT NULL,
        CONSTRAINT fk_receipts
          FOREIGN KEY (receipt_id)
          REFERENCES $RECEIPT_TABLE(id)
          ON DELETE CASCADE)""");

    await db.execute(
      """CREATE UNIQUE INDEX idx_notes_receipt_date
          ON $NOTE_TABLE (receipt_id DESC, date DESC)""");

    // Insert initial data.
    await _updatePreferences(db, Preferences.defaults);
    
    // TODO: Remove the sample receipts.
    await _saveReceipt(db, """{
      "time": "2018-10-28T10:27:00+01:00",
      "currency": "EUR",
      "subtotal": {
        "withoutTax": 21.23,
        "withTax": 22.58,
        "tax": 1.35
      },
      "totalDiscount": {
        "withoutTax": 0,
        "withTax": 0,
        "tax": 0
      },
      "totalPrice": {
        "withoutTax": 21.23,
        "withTax": 22.58,
        "tax": 1.35
      },
      "totalFee": {
        "withoutTax": 0,
        "withTax": 0,
        "tax": 0
      },
      "totalPaid": 22.58,
      "items": [
          {
              "name": "Bananen",
              "quantity": 1.00,
              "unit": "KG",
              "unitPrice": {
                "withoutTax": 2.4346,
                "withTax": 2.59,
                "tax": 0.1554
              },
              "subtotal": {
                "withoutTax": 2.4346,
                "withTax": 2.59,
                "tax": 0.1554
              },
              "totalDiscount": {
                "withoutTax": 0,
                "withTax": 0,
                "tax": 0
              },
              "totalPrice": {
                "withoutTax": 2.4346,
                "withTax": 2.59,
                "tax": 0.1554
              },
              "taxClass": {
                "name": "Food rate",
                "fraction": 0.06
              },
              "description": "bananen van biologische oorsprong",
              "brand": "AH Biologisch"
          },
          {
              "name": "Baby dry pants maat 5",
              "quantity": 3,
              "unit": "pc",
              "unitPrice": {
                "withoutTax": 9.3906,
                "withTax": 9.99,
                "tax": 0.5994
              },
              "subtotal": {
                "withoutTax": 28.1718,
                "withTax": 29.97,
                "tax": 1.7982
              },
              "totalDiscount": {
                "withoutTax": 9.3906,
                "withTax": 9.99,
                "tax": 0.5994
              },
              "totalPrice": {
                "withoutTax": 18.7812,
                "withTax": 19.98,
                "tax": 1.1988
              },
              "taxClass": {
                "name": "Food rate",
                "fraction": 0.06
              },
              "description": "Luiers om lekker in te spelen en toch droog te blijven.",
              "brand": "Pampers",
              "discounts": [{
                  "name": "2 + 1 gratis",
                  "deduct": {
                    "withoutTax": 9.3906,
                    "withTax": 9.99,
                    "tax": 0.5994
                  }
              }] 
          }
      ],
      "payments": [
          {
              "method": "cash",
              "amount": 20.00,
              "meta": {
                  "tendered": 20.00,
                  "change": 0.00
              }
          },
          {
              "method": "card",
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
          "identifier": "albert-heijn-1376",
          "name": "Albert Heijn 1376",
          "address": "Amsterdamsestraatweg 367A, 3551CK, Utrecht",
          "phone": "030-2420200",
          "vatNumber": "NL002230884b01",
          "kvkNumber": "35012085",
          "email": "info@ah.nl",
          "web": "https://www.ah.nl/winkel/1376",
          "meta": {
            "operator": "Henny van de Hoek"
          }
      }
    }""");

    await _saveReceipt(db, """{
      "time": "2017-10-28T10:27:00+01:00",
      "currency": "EUR",
      "subtotal": {
        "withoutTax": 14.1,
        "withTax": 15,
        "tax": 0.9
      },
      "totalDiscount": {
          "withoutTax": 4.7,
          "withTax": 5,
          "tax": 0.3
      },
      "totalPrice": {
          "withoutTax": 9.4,
          "withTax": 10,
          "tax": 0.6
      },
      "totalFee": {
          "withoutTax": 0,
          "withTax": 0,
          "tax": 0
      },
      "totalPaid": 10,
      "items": [
          {
              "name": "Kaars",
              "quantity": 2,
              "unit": "pc",
              "unitPrice": {
                "withoutTax": 2.35,
                "withTax": 2.5,
                "tax": 0.15
              },
              "subtotal": {
                "withoutTax": 4.7,
                "withTax": 5,
                "tax": 0.3
              },
              "totalDiscount": {
                "withoutTax": 0,
                "withTax": 0,
                "tax": 0
              },
              "totalPrice": {
                "withoutTax": 4.7,
                "withTax": 5,
                "tax": 0.3
              },
              "taxClass": {
                "name": "Food rate",
                "fraction": 0.06
              },
              "brand": "Honeybush"
          },
          {
              "name": "Aansteker",
              "quantity": 10,
              "unit": "pc",
              "unitPrice": {
                "withoutTax": 0.94,
                "withTax": 1,
                "tax": 0.06
              },
              "subtotal": {
                "withoutTax": 9.4,
                "withTax": 10,
                "tax": 0.6
              },
              "totalDiscount": {
                  "withoutTax": 4.7,
                  "withTax": 5,
                  "tax": 0.3
              },
              "totalPrice": {
                  "withoutTax": 4.7,
                  "withTax": 5,
                  "tax": 0.3
              },
              "taxClass": {
                  "name": "Food rate",
                  "fraction": 0.06
              },
              "brand": "Jumbo",
              "discounts": [{
                "name": "2e gratis",
                "deduct": {
                  "withoutTax": 4.7,
                  "withTax": 5,
                  "tax": 0.3
                }
              }]
          }
      ],
      "payments": [
          {
              "method": "card",
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
          "identifier": "jumbo-utrecht-merelstraat",
          "name": "Jumbo Utrecht Merelstraat",
          "address": "Merelstraat 46, 3514 CN Utrecht",
          "phone": "030-6630160",
          "vatNumber": "NL00123012303",
          "kvkNumber": "87234821",
          "email": "info@jumbosupermarkten.nl",
          "web": "https://www.jumbo.com/winkels/jumbo-utrecht-merelstraat/",
          "meta": {
            "operator": "Pietje Dirk"
          }
      }
    }""");

    await _saveReceipt(db, """{
      "time": "2019-01-11T11:27:00+01:00",
      "currency": "EUR",
      "subtotal": {
        "withoutTax": 4.18,
        "withTax": 4.59,
        "tax": 0.41
      },
      "totalDiscount": {
          "withoutTax": 0,
          "withTax": 0,
          "tax": 0
      },
      "totalPrice": {
        "withoutTax": 4.18,
        "withTax": 4.59,
        "tax": 0.41
      },
      "totalFee": {
          "withoutTax": 0,
          "withTax": 0,
          "tax": 0
      },
      "totalPaid": 4.59,
      "items": [
          {
              "name": "Prrrikweg",
              "quantity": 1,
              "unit": "pc",
              "unitPrice": {
                "withoutTax": 4.18,
                "withTax": 4.59,
                "tax": 0.41
              },
              "subtotal": {
                "withoutTax": 4.18,
                "withTax": 4.59,
                "tax": 0.41
              },
              "totalDiscount": {
                  "withoutTax": 0,
                  "withTax": 0,
                  "tax": 0
              },
              "totalPrice": {
                "withoutTax": 4.18,
                "withTax": 4.59,
                "tax": 0.41
              },
              "taxClass": {
                  "name": "Food rate",
                  "fraction": 0.09
              },
              "brand": "A. Vogel"
          }
      ],
      "payments": [
          {
              "method": "card",
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
          "identifier": "kruidvat-20850",
          "name": "Kruidvat",
          "address": "Amsterdamsestraatweg 391, 3551 CL Utrecht",
          "phone": "0318-798000",
          "vatNumber": "NL001229847123",
          "kvkNumber": "98375892",
          "email": "klantenservice@kruidvat.nl",
          "web": "https://www.kruidvat.nl/winkel/DROGISTERIJ%20KRUIDVAT%20850",
          "meta": {
            "operator": "Suraya Vos"
          }
      }
    }""");

    print("Created tables");
  }

  Future<void> updatePreferences(Preferences preferences) async {
    var dbClient = await db;
    await _updatePreferences(dbClient, preferences);
  }

  Future<void> _updatePreferences(DatabaseExecutor db, Preferences preferences) async {
    await db.insert(PREFERENCE_TABLE, {
      "includeTax": preferences.includeTax
    });
  }

  Future<Preferences> getPreferences() async {
    var dbClient = await db;
    var map = await dbClient.rawQuery(
      """SELECT * FROM $PREFERENCE_TABLE
          WHERE id = (SELECT MAX(id) FROM $PREFERENCE_TABLE)""");
    if (map == null || map.isEmpty) {
      return Preferences.defaults;
    }
    
    var obj = map.first;
    return Preferences()
      ..includeTax = obj['includeTax'] == 1;
  }

  /// Retrieves all receipts.
  Future<List<Receipt>> getReceipts(int offset, int length) async {
    var dbClient = await db;
    List<Map> list = 
      await dbClient.rawQuery(
        """SELECT r.id, r.receipt 
            FROM $RECEIPT_TABLE r
            INNER JOIN $ACTIVE_RECEIPT_TABLE a ON a.receipt_id = r.id
            ORDER BY r.id DESC
            LIMIT ? OFFSET ?""",
            [length, offset]);
    return list.map(_fromMap).toList();
  }

  Future<ReceiptState> getReceiptState(Receipt receipt) async {
    var dbClient = await db;
    var list = await dbClient.rawQuery(
      """SELECT 1 AS active, 0 AS deleted
          FROM $ACTIVE_RECEIPT_TABLE
          WHERE receipt_id = :1
          UNION ALL
          SELECT 0 AS active, 1 as deleted
          FROM $RECYCLE_BIN_TABLE
          WHERE receipt_id = :1
          """,
      [receipt.id]
    );

    ReceiptState result;
    if (list == null || list.isEmpty) {
      result = ReceiptState.unknown;
    }
    else if (list.length == 1) {
      result = list[0]["active"] == 1 ? ReceiptState.active : ReceiptState.deleted;
    }
    else {
      throw DataException(
        "Getting receipt state returned more than 1 receipt." +
        "This indicates corrupt data."
      );
    }

    return result;
  }

  /// Retrieves all receipts.
  Future<List<Receipt>> getDeletedReceipts(int offset, int length) async {
    var dbClient = await db;
    List<Map> list = 
      await dbClient.rawQuery(
        """SELECT r.id, r.receipt 
            FROM $RECEIPT_TABLE r
            INNER JOIN $RECYCLE_BIN_TABLE b ON b.receipt_id = r.id
            ORDER BY r.id DESC
            LIMIT ? OFFSET ?""",
            [length, offset]);
    return list.map(_fromMap).toList();
  }

  /// Stores the specified receipt.
  Future<Receipt> saveReceipt(String receipt) async {
    // TODO: Check for doubles
    var dbClient = await db;
    Receipt result;

    await dbClient.transaction((txn) async {
      int id = await _saveReceipt(txn, receipt);

      var inserted = await txn.query(
        RECEIPT_TABLE, 
        where: "id = ?", 
        whereArgs: [id]);
      result = _fromMap(inserted.first);
    });

    if (result != null) notifyDataChanged();
    return result;
  }

  Future<int> _saveReceipt(DatabaseExecutor db, String receipt) async {
    return await db.insert(RECEIPT_TABLE, {"receipt": receipt});
  }

  Future<List<Receipt>> search(String search, int offset, int length) async {
    search = search.toLowerCase();

    // TODO: This sucks. Do an actual search in the database.
    List<Receipt> receipts = await getReceipts(offset, length * 2);
    receipts.retainWhere((receipt) => 
      receipt.vendor.name.toLowerCase().contains(search)
      || receipt.items.any((item) => item.name.toLowerCase().contains(search)));
  
    return receipts;
  }

  Future<bool> undelete(Receipt receipt) async {
    return undeleteBatch([receipt]);
  }

  Future<bool> undeleteBatch(Iterable<Receipt> receipts) async {
    int count = receipts.length;
    if (count == 0) {
      return false;
    }

    String questionMarks = receipts.map((r) => "?").join(",");
    var receiptIds = receipts.map((r) => r.id).toList();
    var dbClient = await db;

    bool result;
    await dbClient.transaction((txn) async {
      int deleted = await txn.rawDelete(
        "DELETE FROM $RECYCLE_BIN_TABLE WHERE receipt_id in ($questionMarks)", 
        receiptIds);
      
      if (deleted < count) {
        var bin = await txn.rawQuery(
          "SELECT id FROM $ACTIVE_RECEIPT_TABLE WHERE receipt_id in ($questionMarks)",
          receiptIds);
          
        if (bin == null || bin.length < count) {
          throw DataException(
            "Could not delete receipt(s), because they/some do not exist.");
        }

        result = false;
      }
      else if (deleted == count) {
        for (var id in receiptIds) {
          await txn.insert(
            ACTIVE_RECEIPT_TABLE, 
            {
              "receipt_id": id
            });
        }

        result = true;
      }
      else {
        throw DataException(
          "Expected to delete $count active receipt(s). Would delete $deleted.");
      }
    });


    if (result == true) {
      notifyDataChanged();
    }

    return result;
  }

  Future<bool> delete(Receipt receipt) async {
    return deleteBatch([receipt]);
  }

  Future<bool> deleteBatch(Iterable<Receipt> receipts) async {
    int count = receipts.length;
    if (count == 0) {
      return false;
    }

    String questionMarks = receipts.map((r) => "?").join(",");
    var receiptIds = receipts.map((r) => r.id).toList();
    var dbClient = await db;

    bool result;
    await dbClient.transaction((txn) async {
      int deleted = await txn.rawDelete(
        "DELETE FROM $ACTIVE_RECEIPT_TABLE WHERE receipt_id in ($questionMarks)", 
        receiptIds);
      
      if (deleted < count) {
        var bin = await txn.rawQuery(
          "SELECT id FROM $RECYCLE_BIN_TABLE WHERE receipt_id in ($questionMarks)",
          receiptIds);
          
        if (bin == null || bin.length < count) {
          throw DataException(
            "Could not delete receipt(s), because they/some do not exist.");
        }

        result = false;
      }
      else if (deleted == count) {
        for (var id in receiptIds) {
          await txn.insert(
            RECYCLE_BIN_TABLE, 
            {
              "receipt_id": id
            });
        }

        result = true;
      }
      else {
        throw DataException(
          "Expected to delete $count active receipt(s). Would delete $deleted.");
      }
    });


    if (result == true) {
      notifyDataChanged();
    }

    return result;
  }

  Future<bool> deletePermanently(Receipt receipt) async {
    return deleteBatchPermanently([receipt]);
  }

  Future<bool> deleteBatchPermanently(Iterable<Receipt> receipts) async {
    // TODO: Save the hash of the deleted receipt for future reference.
    int count = receipts.length;
    if (count == 0) {
      return false;
    }

    String questionMarks = receipts.map((r) => "?").join(",");
    var receiptIds = receipts.map((r) => r.id).toList();
    var dbClient = await db;

    bool result;
    int deleted;
    await dbClient.transaction((txn) async {
      deleted = await txn.rawDelete(
      "DELETE FROM $RECEIPT_TABLE WHERE id in ($questionMarks)", 
      receiptIds);
    
      if (deleted < count) {
        result = false;
      }
      else if (deleted == count) {
        result = true;
      }
      else {
        throw DataException(
          "Expected to delete $count active receipt(s). Would delete $deleted.");
      }
    });

    if (deleted > 0) {
      notifyDataChanged();
    }

    return result;
  }

  Future<void> emptyRecycleBin() async {
    var dbClient = await db;
    int deleted = await dbClient.rawDelete(
      """DELETE FROM $RECEIPT_TABLE 
          WHERE id in (SELECT receipt_id 
                      FROM $RECYCLE_BIN_TABLE)""");

    if (deleted > 0) {
      notifyDataChanged();
    }
  }

  Future<int> getRecycleBinSize() async {
    var dbClient = await db;
    var map = await dbClient.rawQuery("SELECT COUNT(*) as count FROM $RECYCLE_BIN_TABLE");
    return map[0]["count"] as int;
  }

  Future<String> getComments(Receipt receipt) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
      """SELECT note,
          MAX(date) AS date
          FROM $NOTE_TABLE 
          GROUP BY receipt_id
          HAVING receipt_id = ?""", 
      [receipt.id]
    );

    String note;
    if (result == null || result.isEmpty) {
      note = "";
    }
    else {
      note = result.first["note"] as String;
    }

    return note;
  }

  Future updateComments(Receipt receipt, String notes) async {
    var dbClient = await db;
    
    if (notes == null || notes.isEmpty) notes = null;
    await dbClient.transaction((txn) async {
      int id = await txn.rawInsert(
        """INSERT INTO $NOTE_TABLE (receipt_id, note, date)
            VALUES (?, ?, julianday('now'))""",
        [receipt.id, notes]);
      
      // Remove any previous changes from the last 15 minutes.
      await txn.delete(
        NOTE_TABLE,
        where: """id != ? AND receipt_id = ? 
          AND date > julianday('now', '-15 minutes')""",
        whereArgs: [id, receipt.id]
      );
    });
  }

  Receipt _fromMap(Map map) {
    try {
      var receiptJson = json.decode(map["receipt"]);
      Receipt receipt = Receipt.fromJson(receiptJson);
      receipt.id = map["id"] as int;
      return receipt;
    }
    catch (e)
    {
      debugPrint("Failed to deserialize receipt:\n$e");
      throw InvalidReceiptException(e.toString());
    }
  }
}