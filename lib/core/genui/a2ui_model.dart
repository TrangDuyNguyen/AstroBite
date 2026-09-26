import 'dart:convert';

/// Domain entity representing a dynamic UI component generated via the A2UI protocol.
class A2uiComponent {
  const A2uiComponent({
    required this.id,
    required this.type,
    required this.props,
  });

  final String id;
  final String type;
  final Map<String, dynamic> props;

  factory A2uiComponent.fromMap(Map<String, dynamic> map) {
    return A2uiComponent(
      id: map['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: map['type']?.toString() ?? 'unknown',
      props: map['props'] is Map
          ? Map<String, dynamic>.from(map['props'] as Map)
          : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'props': props,
      };

  String toJson() => jsonEncode(toMap());
}

/// Parsed result of an A2UI message from the AI Agent.
class A2uiMessagePayload {
  const A2uiMessagePayload({
    required this.text,
    this.components = const [],
    this.surface = 'chat_cockpit',
  });

  final String text;
  final List<A2uiComponent> components;
  final String surface;

  bool get hasComponents => components.isNotEmpty;
}
