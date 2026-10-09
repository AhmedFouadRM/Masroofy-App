import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_bottom_bar.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The prominent disclosure Google Play requires before the SMS permission
/// prompt. A full page, not a tooltip. Pops `true` on **Continue** and `false`
/// on **Not now**; only Continue may go on to ask for the permission.
class SmsDisclosureScreen extends StatelessWidget {
  const SmsDisclosureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    return AuraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.xxxl, AppSpacing.screen, 120),
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colors.surface),
                  child: Icon(Symbols.sms_rounded, size: 40, color: colors.textAccent),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Semantics(header: true, child: Text(StringManager.smsDisclosureTitle, style: text.headlineSmall)),
              const SizedBox(height: AppSpacing.sm),
              Text(
                StringManager.smsDisclosureBody,
                style: text.bodyMedium!.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Point(icon: Symbols.account_balance_rounded, text: StringManager.smsDisclosureBanks),
              _Point(icon: Symbols.block_rounded, text: StringManager.smsDisclosureOtp),
              _Point(icon: Symbols.lock_rounded, text: StringManager.smsDisclosureLocal),
            ],
          ),
        ),
        bottomNavigationBar: GlassBottomBar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(onPressed: () => context.pop(true), child: Text(StringManager.continueLabel)),
              const SizedBox(height: AppSpacing.xs),
              TextButton(onPressed: () => context.pop(false), child: Text(StringManager.notNow)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primarySubtle),
            child: Icon(icon, size: 22, color: colors.textAccent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
