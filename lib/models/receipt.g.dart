// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return Receipt()
    ..time =
        json['time'] == null ? null : DateTime.parse(json['time'] as String)
    ..currency = json['currency'] as String
    ..total = (json['total'] as num)?.toDouble()
    ..tax = (json['tax'] as num)?.toDouble()
    ..items = (json['items'] as List)
        ?.map(
            (e) => e == null ? null : Item.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..payments = (json['payments'] as List)
        ?.map((e) =>
            e == null ? null : Payment.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..loyalties = (json['loyalties'] as List)
        ?.map((e) =>
            e == null ? null : Loyalty.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..vendor = json['vendor'] == null
        ? null
        : Vendor.fromJson(json['vendor'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'time': instance.time?.toIso8601String(),
      'currency': instance.currency,
      'total': instance.total,
      'tax': instance.tax,
      'items': instance.items,
      'payments': instance.payments,
      'loyalties': instance.loyalties,
      'vendor': instance.vendor
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item()
    ..name = json['name'] as String
    ..brand = json['brand'] as String
    ..quantity = (json['quantity'] as num)?.toDouble()
    ..unit = json['unit'] as String
    ..unitPrice = (json['unitPrice'] as num)?.toDouble()
    ..currency = json['currency'] as String
    ..discounts = (json['discounts'] as List)
        ?.map((e) =>
            e == null ? null : Discount.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..subTotal = (json['subTotal'] as num)?.toDouble()
    ..tax = (json['tax'] as num)?.toDouble();
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unitPrice': instance.unitPrice,
      'currency': instance.currency,
      'discounts': instance.discounts,
      'subTotal': instance.subTotal,
      'tax': instance.tax
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..method = json['method'] as String
    ..currency = json['currency'] as String
    ..amount = (json['amount'] as num)?.toDouble()
    ..meta = json['meta'] as Map<String, dynamic>;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'method': instance.method,
      'currency': instance.currency,
      'amount': instance.amount,
      'meta': instance.meta
    };

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return Vendor()
    ..name = json['name'] as String
    ..address = json['address'] as String
    ..telNumber = json['telNumber'] as String
    ..vatNumber = json['vatNumber'] as String
    ..kvkNumber = json['kvkNumber'] as String
    ..web = json['web'] as String
    ..meta = json['meta'] as Map<String, dynamic>;
}

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'telNumber': instance.telNumber,
      'vatNumber': instance.vatNumber,
      'kvkNumber': instance.kvkNumber,
      'web': instance.web,
      'meta': instance.meta
    };

Loyalty _$LoyaltyFromJson(Map<String, dynamic> json) {
  return Loyalty()
    ..points = (json['points'] as num)?.toDouble()
    ..validUntil = json['validUntil'] == null
        ? null
        : DateTime.parse(json['validUntil'] as String);
}

Map<String, dynamic> _$LoyaltyToJson(Loyalty instance) => <String, dynamic>{
      'points': instance.points,
      'validUntil': instance.validUntil?.toIso8601String()
    };

Discount _$DiscountFromJson(Map<String, dynamic> json) {
  return Discount()
    ..name = json['name'] as String
    ..original = (json['original'] as num)?.toDouble()
    ..deduct = (json['deduct'] as num)?.toDouble();
}

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'name': instance.name,
      'original': instance.original,
      'deduct': instance.deduct
    };
