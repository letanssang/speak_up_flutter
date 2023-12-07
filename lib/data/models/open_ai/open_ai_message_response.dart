//{
//   "id": "chatcmpl-8NizH6odOZNjlRsKQx7yRTCyLFLJB",
//   "object": "chat.completion",
//   "created": 1700665167,
//   "model": "gpt-3.5-turbo-0613",
//   "choices": [
//     {
//       "index": 0,
//       "message": {
//         "role": "assistant",
//         "content": "Of course! I'm here to help. What would you like to talk about?"
//       },
//       "finish_reason": "stop"
//     }
//   ],
//   "usage": {
//     "prompt_tokens": 26,
//     "completion_tokens": 17,
//     "total_tokens": 43
//   }
// }
import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/message/message.dart';

part 'open_ai_message_response.g.dart';

@JsonSerializable()
class OpenAIMessageResponse {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<MessageResponseChoice> choices;
  final Map<String, dynamic> usage;

  OpenAIMessageResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
  });

  factory OpenAIMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$OpenAIMessageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OpenAIMessageResponseToJson(this);
}

@JsonSerializable()
class MessageResponseChoice {
  final int index;
  final Message message;
  @JsonKey(name: 'finish_reason')
  final String finishReason;

  MessageResponseChoice({
    required this.index,
    required this.message,
    required this.finishReason,
  });

  factory MessageResponseChoice.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResponseChoiceToJson(this);
}
