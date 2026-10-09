import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/categories/category_icon_registry.dart';
import 'package:masroofy/shared/categories/category_picker_sheet.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/wallets/wallet_avatar.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/wallets/wallet_sheet.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/empty_state_widget.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/glass_bottom_bar.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:masroofy/shared/widgets/select_field.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Add / Edit Expense. Expects an [ExpenseFormCubit] above it.
class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _amount = TextEditingController();
  final _title = TextEditingController();
  final _note = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpenseFormCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<ExpenseFormCubit, ExpenseFormState>(
          listenWhen: (previous, current) =>
              previous.status != ExpenseFormStatus.saved && current.status == ExpenseFormStatus.saved,
          listener: (context, _) => context.pop(),
        ),
        // Fill the fields once the edited expense has loaded.
        BlocListener<ExpenseFormCubit, ExpenseFormState>(
          listenWhen: (previous, current) =>
              previous.status == ExpenseFormStatus.loading && current.status == ExpenseFormStatus.ready,
          listener: (context, state) {
            _amount.text = context.digits(state.amountText);
            _title.text = state.title;
            _note.text = state.note;
          },
        ),
        BlocListener<ExpenseFormCubit, ExpenseFormState>(
          listenWhen: (previous, current) =>
              current.status != ExpenseFormStatus.loadFailure &&
              current.failure != null &&
              current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.failure!)))),
        ),
      ],
      child: BlocBuilder<ExpenseFormCubit, ExpenseFormState>(
        builder: (context, state) => AuraBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: GlassAppBar(
              leading: IconButton(
                icon: const Icon(Symbols.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => context.pop(),
              ),
              title: Text(switch ((state.isEditing, state.isTransfer, state.kind)) {
                (false, true, _) => StringManager.addTransfer,
                (true, true, _) => StringManager.editTransfer,
                (false, false, TransactionKind.expense) => StringManager.addExpense,
                (false, false, TransactionKind.income) => StringManager.addIncome,
                (true, false, TransactionKind.expense) => StringManager.editExpense,
                (true, false, TransactionKind.income) => StringManager.editIncome,
              }),
            ),
            body: switch (state.status) {
              ExpenseFormStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              ExpenseFormStatus.loadFailure => Center(child: Text(StringManager.failure(state.failure!))),
              _ => _Fields(state: state, amount: _amount, title: _title, note: _note),
            },
            bottomNavigationBar:
                state.status == ExpenseFormStatus.loading || state.status == ExpenseFormStatus.loadFailure
                ? null
                : GlassBottomBar(
                    child: FilledButton(
                      onPressed: state.canSave ? cubit.save : null,
                      child: state.status == ExpenseFormStatus.saving
                          ? SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: MasroofyColors.of(context).onPrimary,
                              ),
                            )
                          : Text(switch ((state.isTransfer, state.kind)) {
                              (true, _) => StringManager.saveTransfer,
                              (_, TransactionKind.income) => StringManager.saveIncome,
                              (_, TransactionKind.expense) => StringManager.saveExpense,
                            }),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.state, required this.amount, required this.title, required this.note});

  final ExpenseFormState state;
  final TextEditingController amount;
  final TextEditingController title;
  final TextEditingController note;

  String? _error(String field) => switch (state.errors[field]) {
    ValidationReason.wrongKind => StringManager.wrongKind(state.kind),
    final ValidationReason reason => StringManager.validation(reason),
    null => null,
  };

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<ExpenseFormCubit>();
    final today = LocalDate.today();
    final picked = await showDatePicker(
      context: context,
      initialDate: state.date.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: today.toDateTime(),
    );
    if (picked != null) cubit.dateSelected(LocalDate.fromDateTime(picked));
  }

  /// The Wallet field (after Category), or a transfer's From or To.
  Future<void> _pickWallet(BuildContext context, {required int? selectedId, required bool to}) async {
    final cubit = context.read<ExpenseFormCubit>();
    final defaultId = context.read<SettingsCubit>().state.defaultWalletId;
    final choice = await showWalletSheet(
      context,
      title: StringManager.chooseWallet,
      wallets: state.wallets,
      selectedId: selectedId,
      defaultId: defaultId,
    );
    final id = choice?.walletId;
    if (id == null) return;
    if (to) {
      cubit.toWalletSelected(id);
    } else {
      cubit.walletSelected(id);
    }
  }

  Widget _walletField(
    BuildContext context, {
    required String label,
    required int? walletId,
    required String errorKey,
    required bool to,
  }) {
    final wallet = state.walletById(walletId)?.wallet;
    return SelectField(
      label: label,
      value: wallet?.displayName,
      leading: wallet == null ? null : WalletAvatar(icon: wallet.icon, color: wallet.color, size: 28),
      errorText: _error(errorKey),
      onTap: () => _pickWallet(context, selectedId: walletId, to: to),
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final cubit = context.read<ExpenseFormCubit>();
    final id = await showCategoryPickerSheet(
      context,
      categories: state.pickerCategories,
      selectedId: state.categoryId,
    );
    if (id != null) cubit.categorySelected(id);
  }

  String _dateLabel(BuildContext context) {
    final today = LocalDate.today();
    final date = context.shortDate(state.date);
    if (state.date == today) return StringManager.todayWithDate(date);
    if (state.date == today.addDays(-1)) return StringManager.yesterdayWithDate(date);
    return context.longDate(state.date);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpenseFormCubit>();
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final category = state.category;
    const gap = SizedBox(height: AppSpacing.lg);

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.screen,
        MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
      ),
      children: [
        // Expense | Income | Transfer. A saved row keeps its type, except that
        // an expense and an income can be switched (a misfiled row).
        if (!(state.isEditing && state.isTransfer)) ...[
          SegmentedPills(
            labels: [
              for (final kind in TransactionKind.values) StringManager.kindLabel(kind),
              if (!state.isEditing) StringManager.transferKind,
            ],
            selected: state.isTransfer ? TransactionKind.values.length : state.kind.index,
            onSelected: (i) => i < TransactionKind.values.length
                ? cubit.kindSelected(TransactionKind.values[i])
                : cubit.transferSelected(),
          ),
          gap,
        ],
        if (state.needsSecondWallet)
          EmptyStateWidget(
            icon: Symbols.sync_alt_rounded,
            title: StringManager.transferNeedsTwo,
            actionLabel: StringManager.addWallet,
            actionIcon: Symbols.add_rounded,
            onAction: () => context.push(RoutePaths.newWallet),
          )
        else ...[
          TextField(
            controller: amount,
            autofocus: !state.isEditing,
            keyboardType: TextInputType.numberWithOptions(decimal: state.fractionDigits > 0),
            // Western and Arabic-Indic digits, with `.` or `٫` as decimal point.
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9٠-٩۰-۹.٫,٬]'))],
            style: text.displaySmall!.copyWith(
              fontSize: 28,
              height: 36 / 28,
              color: state.kind == TransactionKind.income && !state.isTransfer ? colors.textPositive : null,
            ),
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
          if (state.isTransfer) ...[
            _walletField(
              context,
              label: StringManager.transferFrom,
              walletId: state.walletId,
              errorKey: 'fromWallet',
              to: false,
            ),
            gap,
            _walletField(
              context,
              label: StringManager.transferTo,
              walletId: state.toWalletId,
              errorKey: 'toWallet',
              to: true,
            ),
          ] else ...[
            SelectField(
              label: StringManager.categoryLabel,
              value: category?.displayName,
              leading: category == null
                  ? null
                  : Icon(CategoryIconRegistry.of(category.icon), color: Color(category.color)),
              errorText: _error('categoryId'),
              onTap: () => _pickCategory(context),
            ),
            gap,
            _walletField(
              context,
              label: StringManager.walletLabel,
              walletId: state.walletId,
              errorKey: 'walletId',
              to: false,
            ),
            gap,
            TextField(
              controller: title,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(AppConstants.maxTitleLength)],
              onChanged: cubit.titleChanged,
              decoration: InputDecoration(
                labelText: StringManager.titleLabel,
                hintText: category?.displayName,
                helperText: StringManager.titleHelper,
                errorText: _error('title'),
              ),
            ),
          ],
          gap,
          SelectField(
            label: StringManager.dateLabel,
            value: _dateLabel(context),
            leading: Icon(Symbols.calendar_today_rounded, color: colors.textSecondary),
            errorText: _error('date'),
            onTap: () => _pickDate(context),
          ),
          gap,
          TextField(
            controller: note,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [LengthLimitingTextInputFormatter(AppConstants.maxNoteLength)],
            onChanged: cubit.noteChanged,
            decoration: InputDecoration(
              labelText: StringManager.noteLabel,
              hintText: StringManager.noteHint,
              alignLabelWithHint: true,
              errorText: _error('note'),
            ),
          ),
        ],
      ],
    );
  }
}
