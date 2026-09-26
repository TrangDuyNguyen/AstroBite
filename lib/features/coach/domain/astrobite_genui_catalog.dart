import 'package:astrobite/core/genui/catalog.dart';
import 'package:astrobite/core/genui/catalog_item.dart';
import 'package:astrobite/features/coach/presentation/widgets/macro_budget_gauge.dart';
import 'package:astrobite/features/coach/presentation/widgets/meal_quick_log_card.dart';
import 'package:astrobite/features/coach/presentation/widgets/quick_choice_chips.dart';

/// Pre-configured [GenUiCatalog] with the official AstroBite chat cockpit widgets.
GenUiCatalog createAstroBiteCatalog({
  void Function(MealQuickLogProps scaledProps)? onLogMeal,
  void Function(String message)? onSendUserMessage,
}) {
  final catalog = GenUiCatalog();

  // 1. MealQuickLogCard
  catalog.register(
    CatalogItem<MealQuickLogProps>(
      type: 'MealQuickLogCard',
      description: 'Thẻ hiển thị món ăn tương tác kèm 3 macro và 1-Tap Log.',
      parseProps: MealQuickLogProps.fromMap,
      builder: (context, props, ctx) => MealQuickLogCard(
        props: props,
        isLogged: ctx.isLogged,
        onLogMeal: (scaledProps) {
          ctx.onAction?.call('log_meal', scaledProps.toMap());
          onLogMeal?.call(scaledProps);
        },
      ),
    ),
  );

  // 2. MacroBudgetGauge
  catalog.register(
    CatalogItem<MacroBudgetGaugeProps>(
      type: 'MacroBudgetGauge',
      description: 'Đồng hồ tiến độ so sánh lượng calo nạp vào vs ngân sách ngày.',
      parseProps: MacroBudgetGaugeProps.fromMap,
      builder: (context, props, ctx) => MacroBudgetGauge(props: props),
    ),
  );

  // 3. QuickChoiceChips
  catalog.register(
    CatalogItem<QuickChoiceChipsProps>(
      type: 'QuickChoiceChips',
      description: 'Dải các chip gợi ý lựa chọn nhanh ngữ cảnh tiếp theo.',
      parseProps: QuickChoiceChipsProps.fromMap,
      builder: (context, props, ctx) => QuickChoiceChips(
        props: props,
        onSelectChip: (payload) {
          ctx.onSendUserMessage?.call(payload);
          onSendUserMessage?.call(payload);
        },
      ),
    ),
  );

  return catalog;
}
