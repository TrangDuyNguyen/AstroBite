import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/meal_plan_item.dart';
import '../../domain/repositories/meal_plan_repository.dart';

/// Firestore implementation of [MealPlanRepository].
/// Collection path: `users/{userId}/meal_plans`
class MealPlanRepositoryImpl implements MealPlanRepository {
  MealPlanRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _db.collection('users').doc(userId).collection('meal_plans');

  @override
  Future<List<MealPlanItem>> getMealPlanItems(String userId, String date) async {
    final snap = await _col(userId)
        .where('date', isEqualTo: date)
        .orderBy('mealType')
        .get();
    return snap.docs.map((d) => _fromDoc(d.id, d.data())).toList();
  }

  @override
  Future<MealPlanItem> saveMealPlanItem(MealPlanItem item) async {
    final data = _toMap(item);
    if (item.id.isEmpty) {
      final ref = await _col(item.userId).add(data);
      return item.copyWith(id: ref.id);
    } else {
      await _col(item.userId).doc(item.id).set(data, SetOptions(merge: true));
      return item;
    }
  }

  Future<void> markAsLoggedForUser(String userId, String itemId) =>
      _col(userId).doc(itemId).update({'isLogged': true});

  Future<void> deleteMealPlanItemForUser(String userId, String itemId) =>
      _col(userId).doc(itemId).delete();

  // ── Mapping helpers ────────────────────────────────────────────────────────

  MealPlanItem _fromDoc(String id, Map<String, dynamic> d) {
    return MealPlanItem(
      id: id,
      userId: d['userId'] as String,
      date: d['date'] as String,
      mealType: d['mealType'] as String,
      recipeId: d['recipeId'] as String?,
      foodName: d['foodName'] as String,
      calories: (d['calories'] as num).toDouble(),
      carbs: (d['carbs'] as num).toDouble(),
      protein: (d['protein'] as num).toDouble(),
      fat: (d['fat'] as num).toDouble(),
      isLogged: (d['isLogged'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> _toMap(MealPlanItem i) => {
        'userId': i.userId,
        'date': i.date,
        'mealType': i.mealType,
        if (i.recipeId != null) 'recipeId': i.recipeId,
        'foodName': i.foodName,
        'calories': i.calories,
        'carbs': i.carbs,
        'protein': i.protein,
        'fat': i.fat,
        'isLogged': i.isLogged,
      };
}
