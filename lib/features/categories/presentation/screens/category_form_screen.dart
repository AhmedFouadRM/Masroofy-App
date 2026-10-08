import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_colors.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/category_icons.dart';
import 'package:masroofy/features/categories/presentation/category_icon_registry.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/categories/presentation/widgets/category_avatar.dart';
import 'package:masroofy/features/categories/presentation/widgets/delete_category_dialog.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:material_symbols_icons/symbols.dart';

/// New / Edit Category. Expects a [CategoryFormCubit] above it.
class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryFormCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryFormCubit, CategoryFormState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              (current.status == CategoryFormStatus.saved || current.status == CategoryFormStatus.deleted),
          listener: (context, _) => context.pop(),
        ),
        // Fill the field once the edited category has loaded.
        BlocListener<CategoryFormCubit, CategoryFormState>(
          listenWhen: (previous, current) =>
              previous.status == CategoryFormStatus.loading && current.status == CategoryFormStatus.ready,
          listener: (context, state) => _name.text = state.name,
        ),
        BlocListener<CategoryFormCubit, CategoryFormState>(
          listenWhen: (previous, current) =>
              current.status != CategoryFormStatus.loadFailure &&
              current.failure != null &&
              current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.failure!)))),
        ),
      ],
      child: BlocBuilder<CategoryFormCubit, CategoryFormState>(
        builder: (context, state) => AuraBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Symbols.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => context.pop(),
              ),
              title: Text(state.isEditing ? StringManager.editCategory : StringManager.newCategory),
              actions: [
                TextButton(onPressed: state.canSave ? cubit.save : null, child: Text(StringManager.save)),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
            body: switch (state.status) {
              CategoryFormStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              CategoryFormStatus.loadFailure => Center(child: Text(StringManager.failure(state.failure!))),
              _ => _Form(state: state, nameController: _name),
            },
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.state, required this.nameController});

  final CategoryFormState state;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryFormCubit>();
    final text = Theme.of(context).textTheme;
    final colors = MasroofyColors.of(context);
    final busy = state.status == CategoryFormStatus.saving || state.status == CategoryFormStatus.deleting;

    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.xxl),
      children: [
        // Live preview.
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Column(
              children: [
                CategoryAvatar(icon: state.icon, color: state.color, size: 56),
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.name.trim().isEmpty ? StringManager.newCategory : state.name.trim(),
                  style: text.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: nameController,
          enabled: !busy,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(AppConstants.maxCategoryNameLength)],
          onChanged: cubit.nameChanged,
          onSubmitted: (_) => cubit.save(),
          decoration: InputDecoration(
            labelText: StringManager.categoryNameLabel,
            helperText: StringManager.categoryNameHelper(context.count(AppConstants.maxCategoryNameLength)),
            errorText: state.nameError == null ? null : StringManager.validation(state.nameError!),
          ),
        ),
        _Heading(StringManager.categoryIcon),
        GridView.count(
          crossAxisCount: 6,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final key in CategoryIcons.keys)
              _IconOption(
                icon: key,
                selected: key == state.icon,
                accent: Color(state.color),
                onTap: () => cubit.iconSelected(key),
              ),
          ],
        ),
        _Heading(StringManager.categoryColour),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final color in AppColors.categoryPalette)
              _ColorSwatch(
                color: color,
                selected: color.toARGB32() == state.color,
                onTap: () => cubit.colorSelected(color.toARGB32()),
              ),
          ],
        ),
        if (state.isEditing) ...[
          const SizedBox(height: AppSpacing.xxl),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textNegative,
              side: BorderSide(color: colors.borderError),
            ),
            icon: const Icon(Symbols.delete_rounded),
            label: Text(StringManager.deleteCategory),
            onPressed: busy || state.usage == null
                ? null
                : () async {
                    if (await showDeleteCategoryDialog(context, state.usage!)) await cubit.delete();
                  },
          ),
        ],
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: AppSpacing.xl, bottom: AppSpacing.md),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

/// A selectable icon tile (Figma local component "Icon Option").
class _IconOption extends StatelessWidget {
  const _IconOption({required this.icon, required this.selected, required this.accent, required this.onTap});

  final String icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      side: selected ? BorderSide(color: colors.primary, width: 2) : BorderSide.none,
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.primarySubtle : colors.surfaceVariant,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(
            CategoryIconRegistry.of(icon),
            color: selected ? accent : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

/// A selectable colour dot with a ring when selected (Figma "Color Swatch").
class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: selected ? colors.primary : Colors.transparent, width: 2),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ),
    );
  }
}
