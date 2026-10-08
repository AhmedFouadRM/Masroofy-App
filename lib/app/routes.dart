/// Route paths (Technical Foundation §6 → route table).
abstract final class RoutePaths {
  static const expenses = '/expenses';
  static const analytics = '/analytics';
  static const settings = '/settings';
  static const newExpense = '/expenses/new';
  static String editExpense(int id) => '/expenses/$id';
  static const recurring = '/expenses/recurring';
  static const lock = '/lock';

  static const categories = '/settings/categories';
  static const newCategory = '/settings/categories/new';
  static String editCategory(int id) => '/settings/categories/$id';
}
