import 'package:flutter/material.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speak_up/data/providers/app_theme_provider.dart';
import 'package:speak_up/domain/entities/message/message.dart';
import 'package:speak_up/domain/use_cases/firestore/messages/get_messages_use_case.dart';
import 'package:speak_up/domain/use_cases/firestore/messages/update_messages_use_case.dart';
import 'package:speak_up/domain/use_cases/open_ai/get_message_response_from_open_ai_use_case.dart';
import 'package:speak_up/injection/injector.dart';
import 'package:speak_up/presentation/pages/chat/chat_state.dart';
import 'package:speak_up/presentation/pages/chat/chat_view_model.dart';
import 'package:speak_up/presentation/resources/app_images.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatState>(
  (ref) => ChatViewModel(
    injector<GetMessageResponseFromOpenAIUseCase>(),
    injector<UpdateMessagesUseCase>(),
    injector<GetMessagesUseCase>(),
  ),
);

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  ChatViewModel get _viewModel => ref.read(chatViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _viewModel.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      body: Container(
        color: isDarkTheme ? Colors.grey[800] : Colors.grey[300],
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(
                    ScreenUtil().setHeight(16) + ScreenUtil().statusBarHeight),
                bottom: ScreenUtil().setHeight(ScreenUtil().setHeight(16)),
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16),
              ),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  //avatar
                  CircleAvatar(
                    radius: ScreenUtil().setWidth(ScreenUtil().setWidth(24)),
                    child: AppImages.chatbot(),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  // name
                  Expanded(
                      child: Text(
                    'Teacher Ba',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  //more vert options
                  PopupMenuButton(itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        onTap: _viewModel.clearMessages,
                        child: Text(AppLocalizations.of(context)!.clearChat),
                      ),
                    ];
                  }),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: isDarkTheme ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(32)),
                        topRight: Radius.circular(ScreenUtil().setWidth(32)),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ChatList(
                      msgCount: state.messages.length,
                      onMsgKey: (int index) => ValueKey(index).toString(),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildMessage(
                            state.messages[state.messages.length - 1 - index],
                            isDarkTheme);
                      },
                    ),
                  ),
                  if (state.responseLoadingStatus == LoadingStatus.loading)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.waitAMoment),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isDarkTheme ? Colors.grey[800] : Colors.white,
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(ScreenUtil().setWidth(8)),
                      decoration: BoxDecoration(
                        color:
                            isDarkTheme ? Colors.grey[850] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _viewModel.textEditingController,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.typeAMessage,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(8)),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                    ),
                    onPressed: _viewModel.getMessageResponseFromOpenAI,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message, bool isDarkTheme) {
    final isChatBot = message.role == 'system' || message.role == 'assistant';
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(8),
        bottom: ScreenUtil().setHeight(8),
        left: isChatBot ? 8 : ScreenUtil().screenWidth * 0.2,
        right: isChatBot ? ScreenUtil().screenWidth * 0.2 : 8,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          color: isChatBot
              ? Theme.of(context).primaryColor
              : isDarkTheme
                  ? Colors.grey[800]
                  : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDarkTheme
                  ? Colors.black.withOpacity(0.25)
                  : Colors.grey.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.only(
              topLeft: isChatBot ? Radius.zero : const Radius.circular(16),
              topRight: isChatBot ? const Radius.circular(16) : Radius.zero,
              bottomRight: const Radius.circular(16),
              bottomLeft: const Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isChatBot
                    ? Colors.white
                    : isDarkTheme
                        ? Colors.white
                        : Colors.black,
                fontSize: ScreenUtil().setSp(16),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
