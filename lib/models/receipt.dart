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
  double total;
  double tax;
  List<Item> items;
  List<Payment> payments;
  List<Loyalty> loyalties;
  Vendor vendor;

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptToJson(this);
}

@JsonSerializable()
class Item {
  Item();

  String name;
  String brand;
  double quantity;
  String unit;
  double unitPrice;
  String currency;
  List<Discount> discounts;
  double subTotal;
  double tax;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Payment {
  Payment();

  String method;
  String currency;
  double amount;
  Map<String, dynamic> meta;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class Vendor {
  Vendor();

  String name;
  String address;
  String telNumber;
  String vatNumber;
  String kvkNumber;
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
  double original;
  double deduct;

  factory Discount.fromJson(Map<String, dynamic> json) => _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}