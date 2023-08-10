import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable()
class Category {
  @JsonKey(name: 'CategoryID')
  final int categoryID;
  @JsonKey(name: 'Name')
  final String name;
  @JsonKey(name: 'Translation')
  final String translation;
  @JsonKey(name: 'ImageURL')
  final String imageUrl;
  Category({
    required this.categoryID,
    required this.name,
    required this.translation,
    required this.imageUrl,
  });
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  factory Category.initial() => Category(
        categoryID: 0,
        name: '',
        translation: '',
        imageUrl: '',
      );
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
