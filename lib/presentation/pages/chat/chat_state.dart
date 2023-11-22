import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/data/models/open_ai/open_ai_message_response.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(LoadingStatus.initial) LoadingStatus responseLoadingStatus,
    @Default([]) List<Message> messages,
  }) = _ChatState;
}
