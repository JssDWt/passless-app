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
    ..subtotal = json['subtotal'] == null
        ? null
        : Price.fromJson(json['subtotal'] as Map<String, dynamic>)
    ..totalDiscount = json['totalDiscount'] == null
        ? null
        : Price.fromJson(json['totalDiscount'] as Map<String, dynamic>)
    ..totalPrice = json['totalPrice'] == null
        ? null
        : Price.fromJson(json['totalPrice'] as Map<String, dynamic>)
    ..totalFee = json['totalFee'] == null
        ? null
        : Price.fromJson(json['totalFee'] as Map<String, dynamic>)
    ..totalPaid = json['totalPaid'] == null
        ? null
        : Price.fromJson(json['totalPaid'] as Map<String, dynamic>)
    ..items = (json['items'] as List)
        ?.map(
            (e) => e == null ? null : Item.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..payments = (json['payments'] as List)
        ?.map((e) =>
            e == null ? null : Payment.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..vendor = json['vendor'] == null
        ? null
        : Vendor.fromJson(json['vendor'] as Map<String, dynamic>)
    ..vendorReference = json['vendorReference'] as String
    ..fees = (json['fees'] as List)
        ?.map((e) => e == null ? null : Fee.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..loyalties = (json['loyalties'] as List)
        ?.map((e) =>
            e == null ? null : Loyalty.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'time': instance.time?.toIso8601String(),
      'currency': instance.currency,
      'subtotal': instance.subtotal,
      'totalDiscount': instance.totalDiscount,
      'totalPrice': instance.totalPrice,
      'totalFee': instance.totalFee,
      'totalPaid': instance.totalPaid,
      'items': instance.items,
      'payments': instance.payments,
      'vendor': instance.vendor,
      'vendorReference': instance.vendorReference,
      'fees': instance.fees,
      'loyalties': instance.loyalties
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item()
    ..name = json['name'] as String
    ..quantity = (json['quantity'] as num)?.toDouble()
    ..unit = json['unit'] as String
    ..unitPrice = json['unitPrice'] == null
        ? null
        : Price.fromJson(json['unitPrice'] as Map<String, dynamic>)
    ..subtotal = json['subtotal'] == null
        ? null
        : Price.fromJson(json['subtotal'] as Map<String, dynamic>)
    ..totalDiscount = json['totalDiscount'] == null
        ? null
        : Price.fromJson(json['totalDiscount'] as Map<String, dynamic>)
    ..totalPrice = json['totalPrice'] == null
        ? null
        : Price.fromJson(json['totalPrice'] as Map<String, dynamic>)
    ..taxClass = json['taxClass'] == null
        ? null
        : TaxClass.fromJson(json['taxClass'] as Map<String, dynamic>)
    ..shortDescription = json['shortDescription'] as String
    ..description = json['description'] as String
    ..brand = json['brand'] as String
    ..discounts = (json['discounts'] as List)
        ?.map((e) =>
            e == null ? null : Discount.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unitPrice': instance.unitPrice,
      'subtotal': instance.subtotal,
      'totalDiscount': instance.totalDiscount,
      'totalPrice': instance.totalPrice,
      'taxClass': instance.taxClass,
      'shortDescription': instance.shortDescription,
      'description': instance.description,
      'brand': instance.brand,
      'discounts': instance.discounts
    };

Payment _$PaymentFromJson(Map<String, dynamic> json) {
  return Payment()
    ..method = json['method'] as String
    ..amount = (json['amount'] as num)?.toDouble()
    ..meta = json['meta'] as Map<String, dynamic>;
}

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'method': instance.method,
      'amount': instance.amount,
      'meta': instance.meta
    };

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return Vendor()
    ..name = json['name'] as String
    ..address = json['address'] as String
    ..phone = json['phone'] as String
    ..vatNumber = json['vatNumber'] as String
    ..kvkNumber = json['kvkNumber'] as String
    ..logo = json['logo'] as String
    ..email = json['email'] as String
    ..web = json['web'] as String
    ..meta = json['meta'] as Map<String, dynamic>;
}

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'vatNumber': instance.vatNumber,
      'kvkNumber': instance.kvkNumber,
      'logo': instance.logo,
      'email': instance.email,
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
    ..deduct = json['deduct'] == null
        ? null
        : Price.fromJson(json['deduct'] as Map<String, dynamic>);
}

Map<String, dynamic> _$DiscountToJson(Discount instance) =>
    <String, dynamic>{'name': instance.name, 'deduct': instance.deduct};

Fee _$FeeFromJson(Map<String, dynamic> json) {
  return Fee()
    ..name = json['name'] as String
    ..price = json['price'] == null
        ? null
        : Price.fromJson(json['price'] as Map<String, dynamic>)
    ..taxClass = json['taxClass'] == null
        ? null
        : TaxClass.fromJson(json['taxClass'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FeeToJson(Fee instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'taxClass': instance.taxClass
    };

Price _$PriceFromJson(Map<String, dynamic> json) {
  return Price()
    ..withoutTax = (json['withoutTax'] as num)?.toDouble()
    ..withTax = (json['withTax'] as num)?.toDouble()
    ..tax = (json['tax'] as num)?.toDouble();
}

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'withoutTax': instance.withoutTax,
      'withTax': instance.withTax,
      'tax': instance.tax
    };

TaxClass _$TaxClassFromJson(Map<String, dynamic> json) {
  return TaxClass()
    ..name = json['name'] as String
    ..fraction = (json['fraction'] as num)?.toDouble();
}

Map<String, dynamic> _$TaxClassToJson(TaxClass instance) =>
    <String, dynamic>{'name': instance.name, 'fraction': instance.fraction};
