import 'package:json_annotation/json_annotation.dart';
part 'receipt.g.dart';

/// Represents a receipt from a vendor.
@JsonSerializable()
class Receipt {
  Receipt();

  @JsonKey(ignore: true)
  int id;
  DateTime time;
  String currency;
  Price subtotal;
  Price totalDiscount;
  Price totalPrice;
  Price totalFee;
  double totalPaid;
  List<Item> items;
  List<Payment> payments;
  Vendor vendor;
  String vendorReference;
  List<Fee> fees;
  List<Loyalty> loyalties;
  
  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}

@JsonSerializable()
class Item {
  Item();

  String name;
  double quantity;
  String unit;
  Price unitPrice;
  Price subtotal;
  Price totalDiscount;
  Price totalPrice;
  TaxClass taxClass;
  String shortDescription;
  String description;
  String brand;
  List<Discount> discounts;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Payment {
  Payment();

  String method;
  double amount;
  Map<String, dynamic> meta;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class Vendor {
  Vendor();

  String identifier;
  String name;
  String address;
  String phone;
  String vatNumber;
  String kvkNumber;
  String logo;
  String email;
  String web;
  Map<String, dynamic> meta;

  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);
  Map<String, dynamic> toJson() => _$VendorToJson(this);
}

@JsonSerializable()
class Loyalty {
  Loyalty();

  double points;
  DateTime validUntil;

  factory Loyalty.fromJson(Map<String, dynamic> json) => _$LoyaltyFromJson(json);
  Map<String, dynamic> toJson() => _$LoyaltyToJson(this);
}

@JsonSerializable()
class Discount {
  Discount();
  String name;
  Price deduct;

  factory Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}

@JsonSerializable()
class Fee {
  Fee();
  String name;
  Price price;
  TaxClass taxClass;

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);
  Map<String, dynamic> toJson() => _$FeeToJson(this);
}

@JsonSerializable()
class Price {
  Price();
  double withoutTax;
  double withTax;
  double tax;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class TaxClass {
  TaxClass();
  String name;
  double fraction;

  factory TaxClass.fromJson(Map<String, dynamic> json) => _$TaxClassFromJson(json);
  Map<String, dynamic> toJson() => _$TaxClassToJson(this);
}