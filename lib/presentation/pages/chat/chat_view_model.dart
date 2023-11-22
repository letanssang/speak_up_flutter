import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speak_up/data/models/open_ai/open_ai_message_response.dart';
import 'package:speak_up/domain/use_cases/open_ai/get_message_response_from_open_ai_use_case.dart';
import 'package:speak_up/presentation/pages/chat/chat_state.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

class ChatViewModel extends StateNotifier<ChatState> {
  ChatViewModel(
    this._getMessageResponseFromOpenAIUseCase,
  ) : super(const ChatState());
  final GetMessageResponseFromOpenAIUseCase
      _getMessageResponseFromOpenAIUseCase;
  TextEditingController textEditingController = TextEditingController();

  void init() {
    state =
        state.copyWith(responseLoadingStatus: LoadingStatus.initial, messages: [
      Message(
          role: 'assistant',
          content:
              'Hello ${FirebaseAuth.instance.currentUser!.displayName}, I am your English teacher. How can I help you today?'),
    ]);
  }

  Future<void> getMessageResponseFromOpenAI() async {
    if (!mounted) return;
    state = state.copyWith(responseLoadingStatus: LoadingStatus.loading);
    try {
      addMessage(
          Message(role: 'user', content: textEditingController.text.trim()));
      textEditingController.clear();
      final message =
          await _getMessageResponseFromOpenAIUseCase.run(prepareRequest());
      addMessage(message);
    } catch (e) {
      state = state.copyWith(responseLoadingStatus: LoadingStatus.error);
    }
  }

  void addMessage(Message message) {
    final newMessages = state.messages.toList();
    newMessages.add(message);
    state = state.copyWith(messages: newMessages);
  }

  List<Map<String, String>> prepareRequest() {
    final List<Map<String, String>> result = [
      {
        "role": "system",
        "content":
            "You are an engaging and knowledgeable English teacher with a great sense of humor."
      }
    ].toList();
    // max 10 messages
    for (var i = 0; i < state.messages.length; i++) {
      if (i < 10) {
        result.add({
          "role": state.messages[i].role,
          "content": state.messages[i].content,
        });
      }
    }
    return result;
  }

  List<Message> convertToMessage(List<Map<String, String>> messages) {
    final List<Message> result = [];
    for (final message in messages) {
      result.add(Message(
        role: message['role'] ?? '',
        content: message['content'] ?? '',
      ));
    }
    return result;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
