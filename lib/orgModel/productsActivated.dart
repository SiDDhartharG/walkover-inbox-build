import 'package:json_annotation/json_annotation.dart';

part 'productsActivated.g.dart';

@JsonSerializable()
class ProductsActivated {
  ProductsActivated();

  late bool doc;
  late bool okr;
  late bool meet;
  late bool inbox;
  late bool sprint;
  late bool channel;
  
  factory ProductsActivated.fromJson(Map<String,dynamic> json) => _$ProductsActivatedFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsActivatedToJson(this);
}
