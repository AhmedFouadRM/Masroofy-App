import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/categories/category_icon_registry.dart';
import 'package:masroofy/shared/categories/category_picker_sheet.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:masroofy/shared/widgets/select_field.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Add / Edit Recurring Expense. Expects a [RecurringFormCubit] above it.
class RecurringFormScreen extends StatefulWidget {
  const RecurringFormScreen({super.key});

  @override
  State<RecurringFormScreen> createState() => _RecurringFormScreenState();
}

class _RecurringFormScreenState extends State<RecurringFormScreen> {
  final _amount = TextEditingController();
  final _title = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecurringFormCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<RecurringFormCubit, RecurringFormState>(
          listenWhen: (previous, current) =>
              previous.status != RecurringFormStatus.saved && current.status == RecurringFormStatus.saved,
          listener: (context, _) => context.pop(),
        ),
        // Fill the fields once the edited template has loaded.
        BlocListener<RecurringFormCubit, RecurringFormState>(
          listenWhen: (previous, current) =>
              previous.status == RecurringFormStatus.loading && current.status == RecurringFormStatus.ready,
          listener: (context, state) {
            _amount.text = context.digits(state.amountText);
            _title.text = state.title;
          },
        ),
        BlocListener<RecurringFormCubit, RecurringFormState>(
          listenWhen: (previous, current) =>
              current.status != RecurringFormStatus.loadFailure &&
              current.failure != null &&
              current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.failure!)))),
        ),
      ],
      child: BlocBuilder<RecurringFormCubit, RecurringFormState>(
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
              title: Text(state.isEditing ? StringManager.editRecurring : StringManager.addRecurring),
            ),
            body: switch (state.status) {
              RecurringFormStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              RecurringFormStatus.loadFailure => Center(child: Text(StringManager.failure(state.failure!))),
              _ => _Fields(state: state, amount: _amount, title: _title),
            },
            bottomNavigationBar:
                state.status == RecurringFormStatus.loading || state.status == RecurringFormStatus.loadFailure
                ? null
                : SafeArea(
                    minimum: const EdgeInsets.all(AppSpacing.lg),
                    child: FilledButton(
                      onPressed: state.canSave ? cubit.save : null,
                      child: state.status == RecurringFormStatus.saving
                          ? SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: MasroofyColors.of(context).onPrimary,
                              ),
                            )
                          : Text(StringManager.saveRecurring),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.state, required this.amount, required this.title});

  final RecurringFormState state;
  final TextEditingController amount;
  final TextEditingController title;

  String? _error(String field) => switch (state.errors[field]) {
    final ValidationReason reason => StringManager.validation(reason),
    null => null,
  };

  Future<void> _pickStartDate(BuildContext context) async {
    final cubit = context.read<RecurringFormCubit>();
    final today = LocalDate.today();
    // Past dates back-fill (within the cap); future ones wait until then.
    final picked = await showDatePicker(
      context: context,
      initialDate: state.startDate.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year + 5, 12, 31),
    );
    if (picked != null) cubit.startDateSelected(LocalDate.fromDateTime(picked));
  }

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<RecurringFormCubit>();
    final id = await showCategoryPickerSheet(context, categories: state.categories, selectedId: state.categoryId);
    if (id != null) cubit.categorySelected(id);
  }

  String _startLabel(BuildContext context) {
    final today = LocalDate.today();
    final date = context.shortDate(state.startDate);
    if (state.startDate == today) return StringManager.todayWithDate(date);
    if (state.startDate == today.addDays(-1)) return StringManager.yesterdayWithDate(date);
    return context.longDate(state.startDate);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecurringFormCubit>();
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final category = state.category;
    const gap = SizedBox(height: AppSpacing.lg);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      children: [
        TextField(
          controller: amount,
          autofocus: !state.isEditing,
          keyboardType: TextInputType.numberWithOptions(decimal: state.fractionDigits > 0),
          // Western and Arabic-Indic digits, with `.` or `٫` as decimal point.
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9٠-٩۰-۹.٫,٬]'))],
          style: text.displaySmall!.copyWith(fontSize: 28, height: 36 / 28),
          textInputAction: TextInputAction.next,
          onChanged: cubit.amountChanged,
          decoration: InputDecoration(
            labelText: StringManager.amountLabel,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: AppSpacing.lg, end: AppSpacing.sm),
              child: Text(context.currencyLabel, style: text.labelLarge!.copyWith(color: colors.textSecondary)),
            ),
            prefixIconConstraints: const BoxConstraints(),
            helperText: StringManager.amountHelper(context.count(state.fractionDigits), context.currency.code),
            errorText: _error('amount'),
          ),
        ),
        gap,
        SelectField(
          label: StringManager.categoryLabel,
          value: category?.displayName,
          leading: category == null ? null : Icon(CategoryIconRegistry.of(category.icon), color: Color(category.color)),
          errorText: _error('categoryId'),
          onTap: () => _pickCategory(context),
        ),
        gap,
        TextField(
          controller: title,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(AppConstants.maxTitleLength)],
          onChanged: cubit.titleChanged,
          decoration: InputDecoration(
            labelText: StringManager.recurringTitleLabel,
            hintText: StringManager.recurringTitleHint,
            errorText: _error('title'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(StringManager.repeats, style: text.labelLarge!.copyWith(color: colors.textSecondary)),
        ),
        SegmentedPills(
          labels: [for (final f in RecurringFrequency.values) StringManager.frequency(f.name)],
          selected: state.frequency.index,
          onSelected: (i) => cubit.frequencySelected(RecurringFrequency.values[i]),
        ),
        const SizedBox(height: AppSpacing.xl),
        SelectField(
          label: StringManager.startDate,
          value: _startLabel(context),
          leading: Icon(Symbols.calendar_today_rounded, color: colors.textSecondary),
          helperText: StringManager.startDateHelper,
          onTap: () => _pickStartDate(context),
        ),
        if (state.isEditing) ...[
          gap,
          Card(
            clipBehavior: Clip.antiAlias,
            child: SwitchListTile(
              title: Text(StringManager.recurringActive),
              subtitle: Text(StringManager.recurringActiveHelper),
              value: state.isActive,
              onChanged: (active) => cubit.activeChanged(active: active),
            ),
          ),
        ],
      ],
    );
  }
}
