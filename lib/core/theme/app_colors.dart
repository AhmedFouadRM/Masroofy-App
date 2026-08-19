import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF66BB6A);
  
  // Surface
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF121212);
  
  // Text
  static const Color textPrimaryLight = Color(0xFF1C1C1E);
  static const Color textPrimaryDark = Color(0xFFE5E5E5);
  
  // Status
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF9A825);
  static const Color positive = Color(0xFF2E7D32);
  static const Color negative = Color(0xFFD32F2F);
  
  // Budget status
  static const Color budgetSafe = Color(0xFF2E7D32);
  static const Color budgetWarning = Color(0xFFF9A825);
  static const Color budgetExceeded = Color(0xFFD32F2F);

  // Category colors
  static const Color categoryFood = Color(0xFFFF7043);
  static const Color categoryTransport = Color(0xFF42A5F5);
  static const Color categoryShopping = Color(0xFFAB47BC);
  static const Color categoryBills = Color(0xFFFFA726);
  static const Color categoryHealth = Color(0xFFEF5350);
  static const Color categoryEntertainment = Color(0xFF26C6DA);
  static const Color categoryEducation = Color(0xFF5C6BC0);
  static const Color categoryOther = Color(0xFF78909C);
  
  static const List<Color> categoryPalette = [
    categoryFood, categoryTransport, categoryShopping, categoryBills,
    categoryHealth, categoryEntertainment, categoryEducation, categoryOther,
  ];
}
