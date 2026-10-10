import 'package:flutter/material.dart';
import 'package:astrobite/core/genui/catalog.dart';
import '../../domain/chat_message.dart';
import 'coach_chat_bubble.dart';
import 'coach_typing_indicator.dart';

/// Message list view displaying chat history with typing indicator.
class CoachMessageList extends StatelessWidget {
  const CoachMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.isSending,
    required this.hasPhysicalKeyboard,
    required this.isInTabs,
    required this.loggedMessageIds,
    required this.genUiCatalog,
    required this.onLogMeal,
    required this.onSendMessage,
    required this.onRetry,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isSending;
  final bool hasPhysicalKeyboard;
  final bool isInTabs;
  final Set<String> loggedMessageIds;
  final GenUiCatalog genUiCatalog;
  final void Function(String messageId, Map<String, dynamic> mealData) onLogMeal;
  final ValueChanged<String> onSendMessage;
  final void Function(ChatMessage message) onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        hasPhysicalKeyboard ? 16 : (isInTabs ? 96 : 24),
      ),
      itemCount: messages.length + (isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isSending) {
          return const CoachTypingIndicator();
        }
        final msg = messages[index];
        return CoachChatBubble(
          message: msg,
          isLogged: msg.isLogged || loggedMessageIds.contains(msg.id),
          genUiCatalog: genUiCatalog,
          onLogMeal: onLogMeal,
          onSendUserMessage: onSendMessage,
          onRetry: () => onRetry(msg),
        );
      },
    );
  }
}
