import 'package:flutter/widgets.dart';
import 'package:masroofy/features/categories/domain/category_icons.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Maps the stored icon keys ([CategoryIcons.keys]) to Material Symbols
/// Rounded glyphs. Const, so unused glyphs are tree-shaken from the font.
abstract final class CategoryIconRegistry {
  static const Map<String, IconData> icons = {
    'restaurant': Symbols.restaurant_rounded,
    'directions_car': Symbols.directions_car_rounded,
    'shopping_bag': Symbols.shopping_bag_rounded,
    'receipt_long': Symbols.receipt_long_rounded,
    'medical_services': Symbols.medical_services_rounded,
    'movie': Symbols.movie_rounded,
    'school': Symbols.school_rounded,
    'more_horiz': Symbols.more_horiz_rounded,
    'local_cafe': Symbols.local_cafe_rounded,
    'local_grocery_store': Symbols.local_grocery_store_rounded,
    'fastfood': Symbols.fastfood_rounded,
    'home': Symbols.home_rounded,
    'bolt': Symbols.bolt_rounded,
    'water_drop': Symbols.water_drop_rounded,
    'wifi': Symbols.wifi_rounded,
    'smartphone': Symbols.smartphone_rounded,
    'cleaning_services': Symbols.cleaning_services_rounded,
    'chair': Symbols.chair_rounded,
    'local_gas_station': Symbols.local_gas_station_rounded,
    'local_taxi': Symbols.local_taxi_rounded,
    'directions_bus': Symbols.directions_bus_rounded,
    'flight': Symbols.flight_rounded,
    'hotel': Symbols.hotel_rounded,
    'local_parking': Symbols.local_parking_rounded,
    'fitness_center': Symbols.fitness_center_rounded,
    'sports_soccer': Symbols.sports_soccer_rounded,
    'pets': Symbols.pets_rounded,
    'child_care': Symbols.child_care_rounded,
    'redeem': Symbols.redeem_rounded,
    'favorite': Symbols.favorite_rounded,
    'spa': Symbols.spa_rounded,
    'content_cut': Symbols.content_cut_rounded,
    'checkroom': Symbols.checkroom_rounded,
    'local_pharmacy': Symbols.local_pharmacy_rounded,
    'work': Symbols.work_rounded,
    'savings': Symbols.savings_rounded,
    'credit_card': Symbols.credit_card_rounded,
    'account_balance': Symbols.account_balance_rounded,
    'volunteer_activism': Symbols.volunteer_activism_rounded,
    'payments': Symbols.payments_rounded,
    'currency_exchange': Symbols.currency_exchange_rounded,
    'trending_up': Symbols.trending_up_rounded,
    'sports_esports': Symbols.sports_esports_rounded,
    'music_note': Symbols.music_note_rounded,
    'menu_book': Symbols.menu_book_rounded,
  };

  /// Unknown keys (e.g. from a newer backup) fall back to `more_horiz`.
  static IconData of(String key) => icons[key] ?? icons[CategoryIcons.fallback]!;
}
