import 'package:flutter/material.dart';
import 'a2ui_model.dart';
import 'catalog_item.dart';

/// The central catalog of widgets that the AI is permitted to generate.
class GenUiCatalog {
  GenUiCatalog({List<CatalogItem<dynamic>>? initialItems}) {
    if (initialItems != null) {
      for (final item in initialItems) {
        register(item);
      }
    }
  }

  final Map<String, CatalogItem<dynamic>> _items = {};

  void register<T>(CatalogItem<T> item) {
    _items[item.type] = item;
  }

  CatalogItem<dynamic>? getItem(String type) => _items[type];

  bool hasItem(String type) => _items.containsKey(type);

  /// Builds the registered Flutter widget from an [A2uiComponent].
  /// Fallback safely if component type is unknown.
  Widget buildWidget(
    BuildContext context,
    A2uiComponent component,
    CatalogItemContext ctx,
  ) {
    final item = _items[component.type];
    if (item == null) {
      return const SizedBox.shrink();
    }

    try {
      return item.buildFromRawProps(context, component.props, ctx);
    } catch (e) {
      // Graceful error widget without crashing
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF93000A).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF93000A), width: 0.5),
        ),
        child: Text(
          'Không thể hiển thị thành phần [${component.type}]',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      );
    }
  }
}
