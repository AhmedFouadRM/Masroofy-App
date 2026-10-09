import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/validation/transfer_validator.dart';
import 'package:masroofy/features/wallets/domain/validation/wallet_validator.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';
import 'package:masroofy/features/wallets/domain/wallet_preselect.dart';

void main() {
  group('WalletValidator', () {
    WalletDraft draft(String? name, {String icon = 'person'}) => WalletDraft(name: name, icon: icon, color: 0xFF000000);

    ValidationFailure? validate(WalletDraft draft, {List<String> taken = const [], bool seeded = false}) =>
        WalletValidator.validate(draft, takenNames: taken, keepsSeedName: seeded);

    test('a name of 1 to 30 characters is valid', () {
      expect(validate(draft('Son')), isNull);
      expect(validate(draft('x' * 30)), isNull);
    });

    test('the name is required and capped', () {
      expect(validate(draft('')), const ValidationFailure(field: 'name', reason: ValidationReason.required));
      expect(validate(draft('  ')), const ValidationFailure(field: 'name', reason: ValidationReason.required));
      expect(validate(draft(null)), const ValidationFailure(field: 'name', reason: ValidationReason.required));
      expect(validate(draft('x' * 31)), const ValidationFailure(field: 'name', reason: ValidationReason.tooLong));
    });

    test('a seeded wallet may keep its name', () {
      expect(validate(draft(null), seeded: true), isNull);
    });

    test('names are unique ignoring case and spacing', () {
      for (final name in ['son', ' SON ', 'Son']) {
        expect(
          validate(draft(name), taken: const ['  sOn']),
          const ValidationFailure(field: 'name', reason: ValidationReason.duplicate),
        );
      }
      expect(validate(draft('Sons'), taken: const ['Son']), isNull);
    });

    test('Arabic and mixed names count as ordinary text', () {
      expect(validate(draft('ابني')), isNull);
      expect(validate(draft('Home بيت')), isNull);
      expect(
        validate(draft('ابني'), taken: const ['ابني']),
        const ValidationFailure(field: 'name', reason: ValidationReason.duplicate),
      );
    });

    test('the icon is one of the eight curated ones', () {
      expect(WalletIcons.keys, ['person', 'woman', 'child', 'home', 'car', 'work', 'savings', 'school']);
      for (final key in WalletIcons.keys) {
        expect(validate(draft('A', icon: key)), isNull);
      }
      expect(
        validate(draft('A', icon: 'rocket')),
        const ValidationFailure(field: 'icon', reason: ValidationReason.invalidFormat),
      );
    });
  });

  group('TransferValidator', () {
    final today = LocalDate(2026, 10, 9);
    final valid = TransferDraft(fromWalletId: 1, toWalletId: 2, amount: const Money(500), date: today);

    ValidationFailure? validate(TransferDraft draft) => TransferValidator.validate(draft, today: today);

    test('a transfer between two different wallets is valid', () {
      expect(validate(valid), isNull);
      expect(validate(valid.copyWith(note: 'x' * 500, date: today.addDays(-30))), isNull);
    });

    test('the wallets must differ', () {
      expect(
        validate(valid.copyWith(toWalletId: 1)),
        const ValidationFailure(field: 'toWallet', reason: ValidationReason.sameWallet),
      );
    });

    test('both wallets are required', () {
      expect(
        validate(valid.copyWith(fromWalletId: 0)),
        const ValidationFailure(field: 'fromWallet', reason: ValidationReason.required),
      );
      expect(
        validate(valid.copyWith(toWalletId: 0)),
        const ValidationFailure(field: 'toWallet', reason: ValidationReason.required),
      );
    });

    test('the amount is positive, the date not in the future, the note short', () {
      expect(
        validate(valid.copyWith(amount: Money.zero)),
        const ValidationFailure(field: 'amount', reason: ValidationReason.mustBePositive),
      );
      expect(
        validate(valid.copyWith(date: today.addDays(1))),
        const ValidationFailure(field: 'date', reason: ValidationReason.inFuture),
      );
      expect(
        validate(valid.copyWith(note: 'x' * 501)),
        const ValidationFailure(field: 'note', reason: ValidationReason.tooLong),
      );
    });
  });

  group('WalletPreselect', () {
    test('viewing a wallet preselects it', () {
      expect(WalletPreselect.initial(viewedWalletId: 2, defaultWalletId: 1), 2);
    });

    test('viewing All wallets preselects the default wallet', () {
      expect(WalletPreselect.initial(viewedWalletId: null, defaultWalletId: 1), 1);
    });

    test('changing the default changes the preselection in All wallets only', () {
      expect(WalletPreselect.initial(viewedWalletId: null, defaultWalletId: 3), 3);
      expect(WalletPreselect.initial(viewedWalletId: 2, defaultWalletId: 3), 2);
    });

    test('nothing is preselected until a default exists', () {
      expect(WalletPreselect.initial(viewedWalletId: null, defaultWalletId: null), isNull);
    });

    test('a preselection that no longer exists falls back to the first wallet', () {
      expect(WalletPreselect.validated(2, [1, 2, 3]), 2);
      expect(WalletPreselect.validated(9, [1, 2, 3]), 1);
      expect(WalletPreselect.validated(null, [4, 5]), 4);
      expect(WalletPreselect.validated(1, const []), isNull);
    });
  });
}
