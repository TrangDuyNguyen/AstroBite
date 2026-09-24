/// Domain entity representing a single chat message in the AI Coach conversation.
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isError = false,
    this.isLogged = false,
  });

  final String id;

  /// `"user"` or `"assistant"`
  final String role;
  final String content;
  final DateTime timestamp;
  final bool isError;
  final bool isLogged;

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    bool? isError,
    bool? isLogged,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        role: role ?? this.role,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        isError: isError ?? this.isError,
        isLogged: isLogged ?? this.isLogged,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'is_error': isError,
        'is_logged': isLogged,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] as String,
        role: map['role'] as String,
        content: map['content'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
        isError: map['is_error'] as bool? ?? false,
        isLogged: map['is_logged'] as bool? ?? false,
      );
}
