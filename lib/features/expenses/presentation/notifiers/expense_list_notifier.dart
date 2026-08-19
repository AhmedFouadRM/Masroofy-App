import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';

// TODO: Implement proper Riverpod AsyncNotifier
class ExpenseListNotifier extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    // TODO: implement build
    return [];
  }
}

final expenseListProvider = AsyncNotifierProvider<ExpenseListNotifier, List<Expense>>(() {
  return ExpenseListNotifier();
});
