import 'package:json_annotation/json_annotation.dart';

part 'productsJoined.g.dart';

@JsonSerializable()
class ProductsJoined {
  ProductsJoined();

  bool channel;
  bool okr;
  bool inbox;

  factory ProductsJoined.fromJson(Map<String, dynamic> json) =>
      _$ProductsJoinedFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsJoinedToJson(this);
}
