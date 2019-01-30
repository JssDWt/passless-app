import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:passless_android/data/data_exception.dart';
import 'package:passless_android/models/preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image/image.dart' as image;

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
  static const String ACTIVE_RECEIPT_TABLE = "active_receipts";
  static const String RECYCLE_BIN_TABLE = "recycle_bin";
  static const String NOTE_TABLE = "notes";
  static const String LOGO_TABLE = "logos";
  static const String PREFERENCE_TABLE = "preferences";

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
          REFERENCES receipts(id)
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
          REFERENCES receipts(id)
          ON DELETE CASCADE)""");
    
    await db.execute(
      """CREATE UNIQUE INDEX idx_recycle_bin_receipt
         ON $RECYCLE_BIN_TABLE (receipt_id DESC)""");

    await db.execute(
      """CREATE TABLE $NOTE_TABLE(
        id INTEGER PRIMARY KEY NOT NULL, 
        receipt_id INTEGER NOT NULL,
        note TEXT NOT NULL, 
        date REAL NOT NULL,
        CONSTRAINT fk_receipts
          FOREIGN KEY (receipt_id)
          REFERENCES receipts(id)
          ON DELETE CASCADE)""");

    await db.execute(
      """CREATE UNIQUE INDEX idx_notes_receipt_date
         ON $NOTE_TABLE (receipt_id DESC, date DESC)""");
    
    await db.execute(
      """CREATE TABLE $LOGO_TABLE(
         id INTEGER PRIMARY KEY NOT NULL,
         receipt_id INTEGER NOT NULL,
         mime_type TEXT NOT NULL,
         width INTEGER NOT NULL,
         height INTEGER NOT NULL,
         logo BLOB NOT NULL,
         CONSTRAINT fk_receipts
           FOREIGN KEY (receipt_id)
           REFERENCES receipts(id)
           ON DELETE CASCADE
      )"""
    );

    await db.execute(
      """CREATE UNIQUE INDEX idx_logos_receipt
         ON $LOGO_TABLE (receipt_id DESC)""");

    


    // Insert initial data.

    await _updatePreferences(db, Preferences.defaults);
    
    // TODO: Remove the sample receipts and their image assets.
    int ahId = await db.rawInsert(
      "INSERT INTO $RECEIPT_TABLE (receipt) VALUES (?)",
      ["""{
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
          "name": "Albert Heijn 1376",
          "address": "Amsterdamsestraatweg 367A, 3551CK, Utrecht",
          "phone": "030-2420200",
          "vatNumber": "NL002230884b01",
          "kvkNumber": "35012085",
          "email": "info@ah.nl",
          "web": "https://www.ah.nl/winkel/1376",
          "logo": null,
          "meta": {
            "operator": "Henny van de Hoek"
          }
      }
    }"""]);

    int jumboId = await db.rawInsert(
      "INSERT INTO $RECEIPT_TABLE (receipt) VALUES (?)",
      ["""{
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
          "name": "Jumbo Utrecht Merelstraat",
          "address": "Merelstraat 46, 3514 CN Utrecht",
          "phone": "030-6630160",
          "vatNumber": "NL00123012303",
          "kvkNumber": "87234821",
          "email": "info@jumbosupermarkten.nl",
          "web": "https://www.jumbo.com/winkels/jumbo-utrecht-merelstraat/",
          "logo": null,
          "meta": {
            "operator": "Pietje Dirk"
          }
      }
    }"""]);
    int kruidvatId = await db.rawInsert(
      "INSERT INTO $RECEIPT_TABLE (receipt) VALUES (?)",
      ["""{
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
    }"""]);

    Uint8List logo = (await rootBundle.load('assets/AH-logo.jpg')).buffer.asUint8List();
    await _saveLogo(db, logo, ahId, "image/jpeg");

    logo = (await rootBundle.load('assets/Jumbo-logo.png')).buffer.asUint8List();
    await _saveLogo(db, logo, jumboId, "image/png");

    logo = (await rootBundle.load('assets/Kruidvat-logo.png')).buffer.asUint8List();
    await _saveLogo(db, logo, kruidvatId, "image/png");

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

  Future<void> _saveLogo(DatabaseExecutor db, Uint8List logo, int receiptId, String mimeType) async {
    image.Image resultingImage;

    // TODO: Fail gracefully
    switch (mimeType) {
      case "image/jpeg":
        resultingImage = image.decodeJpg(logo);
        break;
      case "image/png":
        resultingImage = image.decodePng(logo);
        break;
      default:
        resultingImage = image.decodeImage(logo);
        break;
    }

    await db.rawInsert(
      """INSERT INTO $LOGO_TABLE (receipt_id, mime_type, width, height, logo) VALUES(
      ?, ?, ?, ?, ?
    )""",
    [
      receiptId,
      mimeType,
      resultingImage.width,
      resultingImage.height,
      logo
    ]);
  }

  Future<Image> getLogo(Receipt receipt, double area) async {
    var dbClient = await db;
    List<Map<String, dynamic>> map = await dbClient.rawQuery(
      """SELECT mime_type, width, height, logo FROM $LOGO_TABLE WHERE receipt_id = ?""",
      [receipt.id]);
    if (map.isNotEmpty) {
      var row = map.first;
      int width = row['width'] as int;
      int height = row['height'] as int;
      double ratio = height / width;
      double resultingWidth = sqrt(area / ratio);
      Uint8List bytes = row['logo'] as Uint8List;
      return Image.memory(bytes, width: resultingWidth, fit: BoxFit.contain);
    }
    
    return null;
  }

  /// Retrieves all receipts.
  Future<List<Receipt>> getReceipts() async {
    var dbClient = await db;
    List<Map> list = 
      await dbClient.rawQuery(
        """SELECT r.id, r.receipt 
           FROM $RECEIPT_TABLE r
           INNER JOIN $ACTIVE_RECEIPT_TABLE a ON a.receipt_id = r.id
           ORDER BY r.id DESC""");
    return list.map(_fromMap).toList();
  }

  /// Retrieves all receipts.
  Future<List<Receipt>> getDeletedReceipts() async {
    var dbClient = await db;
    List<Map> list = 
      await dbClient.rawQuery(
        """SELECT r.id, r.receipt 
           FROM $RECEIPT_TABLE r
           INNER JOIN $RECYCLE_BIN_TABLE b ON b.receipt_id = r.id
           ORDER BY r.id DESC""");
    return list.map(_fromMap).toList();
  }

  /// Stores the specified receipt.
  Future<Receipt> saveReceipt(Receipt receipt) async {
    // TODO: Check for doubles
    var dbClient = await db;
    Receipt result;
    bool hasLogo = false;
    String mimeType = null;
    Uint8List bytes = null;

    if (receipt.vendor.logo != null) {
      var logoDataUrl = receipt.vendor.logo;
      receipt.vendor.logo = null;

      int endIndex = logoDataUrl.indexOf(";base64");
      int startIndex = logoDataUrl.indexOf(":") + 1;
      if (endIndex != -1 &&  startIndex != 0) {
        mimeType = logoDataUrl.substring(startIndex, endIndex);
        int logoIndex = logoDataUrl.indexOf(",") + 1;
        if (logoIndex != 0) {
          String logoString = logoDataUrl.substring(logoIndex);
          bytes = base64Decode(logoString);
          hasLogo = true;
        }
      }
    }

    await dbClient.transaction((txn) async {
      int id = await txn.insert(
        RECEIPT_TABLE, 
        {"receipt": json.encode(receipt.toJson())});
      
      if (hasLogo) {
        await _saveLogo(txn, bytes, id, mimeType);
      }

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
    var receiptJson = json.decode(map["receipt"]);
    Receipt receipt = Receipt.fromJson(receiptJson);
    receipt.id = map["id"] as int;
    return receipt;
  }
}