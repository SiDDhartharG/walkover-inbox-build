import 'package:json_annotation/json_annotation.dart';

part 'productsActivated.g.dart';

@JsonSerializable()
class ProductsActivated {
  ProductsActivated();

  bool doc;
  bool okr;
  bool meet;
  bool inbox;
  bool sprint;
  bool channel;

  factory ProductsActivated.fromJson(Map<String, dynamic> json) =>
      _$ProductsActivatedFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsActivatedToJson(this);
}
