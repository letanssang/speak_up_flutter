import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  final String role;

  final String content;

  Message({
    required this.role,
    required this.content,
  });

  Message.fromJson(Map<String, dynamic> json)
      : this(
          role: json['role'],
          content: json['content'],
        );

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
