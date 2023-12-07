import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/domain/entities/message/message.dart';
import 'package:speak_up/domain/use_cases/firestore/messages/get_messages_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/messages/update_messages_use_case.dart';
import 'package:speak_up/domain/use_cases/open_ai/get_message_response_from_open_ai_use_case.dart';
import 'package:speak_up/presentation/pages/chat/chat_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  ChatViewModel(
    this._getMessageResponseFromOpenAIUseCase,
    this._updateMessagesUseCase,
    this._getMessagesUseCase,
  ) : super(const ChatState());
  final GetMessageResponseFromOpenAIUseCase
      _getMessageResponseFromOpenAIUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final UpdateMessagesUseCase _updateMessagesUseCase;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  Future<void> init() async {
    final previousMessages = await _getMessagesUseCase.run();
    if (previousMessages.isEmpty) {
      addMessage(Message(
          role: 'assistant',
          content:
              'Hello ${FirebaseAuth.instance.currentUser!.displayName}, I am your English teacher. How can I help you today?'));
      return;
    }
    state = state.copyWith(messages: previousMessages);
  }

  Future<void> getMessageResponseFromOpenAI() async {
    if (!mounted) return;
    // if text controller is empty, return
    if (textEditingController.text.trim().isEmpty) return;
    state = state.copyWith(responseLoadingStatus: LoadingStatus.loading);
    try {
      addMessage(
          Message(role: 'user', content: textEditingController.text.trim()));
      textEditingController.clear();
      final message =
          await _getMessageResponseFromOpenAIUseCase.run(prepareRequest());
      addMessage(message);
      state = state.copyWith(responseLoadingStatus: LoadingStatus.success);
    } catch (e) {
      state = state.copyWith(responseLoadingStatus: LoadingStatus.error);
    }
  }

  void addMessage(Message message) {
    final newMessages = state.messages.toList();
    newMessages.add(message);
    state = state.copyWith(messages: newMessages);
    _updateMessagesUseCase.run(newMessages);
  }

  List<Map<String, String>> prepareRequest() {
    final List<Map<String, String>> result = [
      {
        "role": "system",
        "content":
            "You are Mr. Ba, an engaging and knowledgeable English teacher with a great sense of humor. You always answer shortly, never more than 2 sentences."
      }
    ].toList();
    // add last messages, max 6
    final int startIndex =
        state.messages.length > 6 ? state.messages.length - 6 : 0;
    for (int i = startIndex; i < state.messages.length; i++) {
      result.add({
        "role": state.messages[i].role,
        "content": state.messages[i].content,
      });
    }
    return result;
  }

  void clearMessages() {
    state = state.copyWith(messages: [
      Message(
          role: 'assistant',
          content:
              'Hello ${FirebaseAuth.instance.currentUser!.displayName}, I am your English teacher. How can I help you today?')
    ]);
    _updateMessagesUseCase.run(state.messages);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
