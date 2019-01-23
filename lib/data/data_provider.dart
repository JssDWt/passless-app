import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  static const String NOTE_TABLE = "notes";
  static const String LOGO_TABLE = "logos";

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
      "CREATE TABLE $RECEIPT_TABLE(id INTEGER PRIMARY KEY, receipt TEXT)");
    
    await db.execute(
      """CREATE TABLE $NOTE_TABLE(
        id INTEGER PRIMARY KEY, 
        receipt_id INTEGER,
        note TEXT, 
        date REAL,
        CONSTRAINT fk_receipts
          FOREIGN KEY (receipt_id)
          REFERENCES receipts(id)
          ON DELETE CASCADE)""");

    await db.execute(
      """CREATE UNIQUE INDEX idx_notes_receipt_date
         ON $NOTE_TABLE (receipt_id DESC, date DESC)""");
    
    await db.execute(
      """CREATE TABLE $LOGO_TABLE(
         id INTEGER PRIMARY KEY,
         receipt_id INTEGER,
         mime_type TEXT,
         width INTEGER,
         height INTEGER,
         logo BLOB,
         CONSTRAINT fk_receipts
           FOREIGN KEY (receipt_id)
           REFERENCES receipts(id)
           ON DELETE CASCADE
      )"""
    );

    await db.execute(
      """CREATE UNIQUE INDEX idx_logos_receipt
         ON $LOGO_TABLE (receipt_id DESC)""");


    // TODO: Remove the sample receipts.
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
    await saveLogo(db, logo, ahId, "image/jpeg");

    logo = (await rootBundle.load('assets/Jumbo-logo.png')).buffer.asUint8List();
    await saveLogo(db, logo, jumboId, "image/png");

    logo = (await rootBundle.load('assets/Kruidvat-logo.png')).buffer.asUint8List();
    await saveLogo(db, logo, kruidvatId, "image/png");

    print("Created tables");
  }

  Future<void> saveLogo(DatabaseExecutor db, Uint8List logo, int receiptId, String mimeType) async {
    image.Image resultingImage;

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
      return Image.memory(bytes, width: resultingWidth);
    }
    
    return null;
  }

  /// Retrieves all receipts.
  Future<List<Receipt>> getReceipts() async {
    var dbClient = await db;
    List<Map> list = 
      await dbClient.rawQuery(
        """SELECT id, receipt FROM $RECEIPT_TABLE
           ORDER BY id DESC""");
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
        await saveLogo(txn, bytes, id, mimeType);
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