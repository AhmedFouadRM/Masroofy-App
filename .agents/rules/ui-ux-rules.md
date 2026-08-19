---
trigger: always_on
---

# Masroofy UI/UX Rules

These rules apply to the presentation layer of the Masroofy app.

## 1. Bilingual & RTL Support
- Masroofy supports Arabic (RTL) and English (LTR).
- Do not use `EdgeInsets.only(left: ..., right: ...)`. Use `EdgeInsetsDirectional.only(start: ..., end: ...)` to ensure proper flipping in RTL.
- Do not use `TextAlign.left` or `TextAlign.right`. Use `TextAlign.start` or `TextAlign.end`.
- Exception: Phone numbers and currency values (if displaying the symbol) generally stay LTR even in Arabic mode, ensure they render correctly.

## 2. Empty States
- Always provide an empty state when lists (expenses, categories, budgets) are empty.
- Use the shared `EmptyStateWidget` from `lib/shared/widgets/empty_state_widget.dart`.
- Include a clear call-to-action (e.g., "Tap + to add your first expense").

## 3. Loading States
- When fetching data via `AsyncValue`, always handle the `loading` and `error` states gracefully.
- Use the shared `LoadingIndicator` from `lib/shared/widgets/loading_indicator.dart`.

## 4. Destructive Actions
- Any action that deletes data (e.g., deleting an expense, clearing all data) MUST prompt for confirmation.
- Use the shared `ConfirmDialog` from `lib/shared/widgets/confirm_dialog.dart`.
- Destructive buttons should use the `AppColors.error` or `AppColors.negative` styling.

## 5. Visual Feedback
- Use `flutter_animate` for subtle entrance animations on lists and cards.
- Give visual feedback when approaching budget limits (Green -> Yellow -> Red) using `AppColors.budgetSafe`, `AppColors.budgetWarning`, and `AppColors.budgetExceeded`.
