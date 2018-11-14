import "package:test/test.dart";
import 'package:passless_android/receipt.dart';
import 'dart:convert';

void main() {
  test('Tests deserialization of a sample receipt.', () {
    String receiptJson = """{
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
    }""";

    Map receiptMap =  json.decode(receiptJson);
    Receipt receipt = Receipt.fromJson(receiptMap);
    String reserialized = json.encode(receipt);
    print(reserialized);
  });
}