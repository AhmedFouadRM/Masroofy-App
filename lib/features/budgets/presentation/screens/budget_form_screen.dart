import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_cubit.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/categories/category_icon_registry.dart';
import 'package:masroofy/shared/categories/category_picker_sheet.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:masroofy/shared/widgets/select_field.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Add / Edit Budget. Expects a [BudgetFormCubit] above it.
class BudgetFormScreen extends StatefulWidget {
  const BudgetFormScreen({super.key});

  @override
  State<BudgetFormScreen> createState() => _BudgetFormScreenState();
}

class _BudgetFormScreenState extends State<BudgetFormScreen> {
  final _limit = TextEditingController();

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BudgetFormCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<BudgetFormCubit, BudgetFormState>(
          listenWhen: (previous, current) =>
              previous.status != BudgetFormStatus.saved && current.status == BudgetFormStatus.saved,
          listener: (context, _) => context.pop(),
        ),
        // Fill the field once the edited budget has loaded.
        BlocListener<BudgetFormCubit, BudgetFormState>(
          listenWhen: (previous, current) =>
              previous.status == BudgetFormStatus.loading && current.status == BudgetFormStatus.ready,
          listener: (context, state) => _limit.text = context.digits(state.limitText),
        ),
        BlocListener<BudgetFormCubit, BudgetFormState>(
          listenWhen: (previous, current) =>
              current.status != BudgetFormStatus.loadFailure &&
              current.failure != null &&
              current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.failure!)))),
        ),
      ],
      child: BlocBuilder<BudgetFormCubit, BudgetFormState>(
        builder: (context, state) => AuraBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: GlassAppBar(
              leading: IconButton(
                icon: const Icon(Symbols.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => context.pop(),
              ),
              title: Text(state.isEditing ? StringManager.editBudget : StringManager.addBudget),
            ),
            body: switch (state.status) {
              BudgetFormStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              BudgetFormStatus.loadFailure => Center(child: Text(StringManager.failure(state.failure!))),
              _ => _Fields(state: state, limit: _limit),
            },
            bottomNavigationBar:
                state.status == BudgetFormStatus.loading || state.status == BudgetFormStatus.loadFailure
                ? null
                : SafeArea(
                    minimum: const EdgeInsets.all(AppSpacing.lg),
                    child: FilledButton(
                      onPressed: state.canSave ? cubit.save : null,
                      child: state.status == BudgetFormStatus.saving
                          ? SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: MasroofyColors.of(context).onPrimary,
                              ),
                            )
                          : Text(StringManager.saveBudget),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.state, required this.limit});

  final BudgetFormState state;
  final TextEditingController limit;

  String? _error(String field) => switch (state.errors[field]) {
    final ValidationReason reason => StringManager.validation(reason),
    null => null,
  };

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<BudgetFormCubit>();
    final id = await showCategoryPickerSheet(context, categories: state.available, selectedId: state.categoryId);
    if (id != null) cubit.categorySelected(id);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BudgetFormCubit>();
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final category = state.category;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      children: [
        SelectField(
          label: StringManager.categoryLabel,
          value: category?.displayName,
          leading: category == null ? null : Icon(CategoryIconRegistry.of(category.icon), color: Color(category.color)),
          helperText: state.isEditing ? StringManager.budgetCategoryLocked : null,
          errorText: _error('categoryId'),
          // The category is fixed once the budget exists.
          onTap: state.isEditing ? null : () => _pickCategory(context),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: limit,
          autofocus: state.isEditing,
          keyboardType: TextInputType.numberWithOptions(decimal: state.fractionDigits > 0),
          // Western and Arabic-Indic digits, with `.` or `٫` as decimal point.
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9٠-٩۰-۹.٫,٬]'))],
          style: text.displaySmall!.copyWith(fontSize: 28, height: 36 / 28),
          onChanged: cubit.limitChanged,
          decoration: InputDecoration(
            labelText: StringManager.budgetLimitLabel,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg, end: AppSpacing.sm),
              child: Text(context.currencyLabel, style: text.labelLarge!.copyWith(color: colors.textSecondary)),
            ),
            prefixIconConstraints: const BoxConstraints(),
            helperText: StringManager.amountHelper(context.count(state.fractionDigits), context.currency.code),
            errorText: _error('limit'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(
            StringManager.budgetPeriodLabel,
            style: text.labelLarge!.copyWith(color: colors.textSecondary),
          ),
        ),
        SegmentedPills(
          labels: [for (final p in BudgetPeriod.values) StringManager.budgetPeriod(p.name)],
          selected: state.period.index,
          onSelected: (i) => cubit.periodSelected(BudgetPeriod.values[i]),
        ),
      ],
    );
  }
}
