/// Keys of the curated category icon set (Material Symbols names). The DB
/// stores the key; presentation maps it to `IconData` (icon fonts are
/// tree-shaken, so names can't be resolved at runtime). Keep in sync with
/// `presentation/category_icon_registry.dart` (a test enforces it).
abstract final class CategoryIcons {
  static const fallback = 'more_horiz';

  static const List<String> keys = [
    // Defaults
    'restaurant', 'directions_car', 'shopping_bag', 'receipt_long',
    'medical_services', 'movie', 'school', fallback,
    // Food & home
    'local_cafe', 'local_grocery_store', 'fastfood', 'home', 'bolt', 'water_drop',
    'wifi', 'smartphone', 'cleaning_services', 'chair',
    // Transport & travel
    'local_gas_station', 'local_taxi', 'directions_bus', 'flight', 'hotel', 'local_parking',
    // Life
    'fitness_center', 'sports_soccer', 'pets', 'child_care', 'redeem', 'favorite',
    'spa', 'content_cut', 'checkroom', 'local_pharmacy',
    // Money & work
    'work', 'savings', 'credit_card', 'account_balance', 'volunteer_activism',
    // Leisure
    'sports_esports', 'music_note', 'menu_book',
  ];
}
