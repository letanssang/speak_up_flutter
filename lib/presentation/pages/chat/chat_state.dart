import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/message/message.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default(LoadingStatus.initial) LoadingStatus responseLoadingStatus,
    @Default([]) List<Message> messages,
  }) = _ChatState;
}
