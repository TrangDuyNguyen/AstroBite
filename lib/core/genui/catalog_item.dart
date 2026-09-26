import 'package:flutter/widgets.dart';

/// Context provided to a [CatalogItem] widget builder to communicate actions.
class CatalogItemContext {
  const CatalogItemContext({
    this.onAction,
    this.onSendUserMessage,
    this.isLogged = false,
  });

  /// Generic action callback (e.g. 'log_meal', 'update_portion').
  final void Function(String action, dynamic payload)? onAction;

  /// Trigger sending a new chat prompt from the user (e.g. via choice chips).
  final void Function(String message)? onSendUserMessage;

  /// Indicates if this item has already been committed/logged to diary.
  final bool isLogged;
}

/// A registered component specification in the GenUI catalog.
class CatalogItem<T> {
  const CatalogItem({
    required this.type,
    required this.description,
    required this.parseProps,
    required this.builder,
  });

  /// The unique type identifier (e.g. 'MealQuickLogCard').
  final String type;

  /// Description of the component for AI schema mapping.
  final String description;

  /// Factory function that parses raw props into strongly-typed [T].
  final T Function(Map<String, dynamic> props) parseProps;

  /// Widget builder function that returns a native Flutter widget.
  final Widget Function(BuildContext context, T props, CatalogItemContext ctx) builder;

  Widget buildFromRawProps(
    BuildContext context,
    Map<String, dynamic> rawProps,
    CatalogItemContext ctx,
  ) {
    final parsed = parseProps(rawProps);
    return builder(context, parsed, ctx);
  }
}
