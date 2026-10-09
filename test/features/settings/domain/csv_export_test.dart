import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/csv_export.dart';
import 'package:masroofy/features/settings/domain/entities/expense_export_row.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';
import 'package:masroofy/features/settings/domain/repositories/i_file_services.dart';
import 'package:masroofy/features/settings/domain/usecases/export_expenses_csv.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements IDataManagementRepository {}

class _MockSharer extends Mock implements IFileSharer {}

String _label({String? seedKey, String? name}) => seedKey != null ? seedKey.toUpperCase() : name ?? '';

String _wallet({String? seedKey, String? name}) => seedKey != null ? 'seed:$seedKey' : name ?? '';

void main() {
  setUpAll(() => registerFallbackValue(Uint8List(0)));

  group('escapeField (RFC 4180)', () {
    test('leaves plain text alone', () {
      expect(CsvExport.escapeField('Lunch'), 'Lunch');
      expect(CsvExport.escapeField(''), '');
      expect(CsvExport.escapeField('غداء'), 'غداء');
      expect(CsvExport.escapeField('a b'), 'a b');
    });

    test('quotes fields with a comma, a quote or a line break', () {
      expect(CsvExport.escapeField('Milk, eggs'), '"Milk, eggs"');
      expect(CsvExport.escapeField('line1\nline2'), '"line1\nline2"');
      expect(CsvExport.escapeField('line1\r\nline2'), '"line1\r\nline2"');
      expect(CsvExport.escapeField('a\rb'), '"a\rb"');
    });

    test('doubles quotes inside a quoted field', () {
      expect(CsvExport.escapeField('The "big" one'), '"The ""big"" one"');
      expect(CsvExport.escapeField('"'), '""""');
    });
  });

  group('encode', () {
    test('joins fields with commas and ends every row, the last too, with CRLF', () {
      expect(
        CsvExport.encode([
          ['a', 'b'],
          ['c', 'd'],
        ]),
        'a,b\r\nc,d\r\n',
      );
    });

    test('quotes inside rows and keeps empty fields', () {
      expect(
        CsvExport.encode([
          ['x', '', 'y,z', 'say "hi"'],
        ]),
        'x,,"y,z","say ""hi"""\r\n',
      );
    });

    test('an empty list is an empty file', () {
      expect(CsvExport.encode([]), '');
    });
  });

  group('records', () {
    final rows = [
      ExpenseExportRow(
        date: LocalDate(2026, 10, 8),
        amount: const Money(1250),
        title: 'Lunch, with "friends"',
        categorySeedKey: 'food',
        walletSeedKey: 'me',
        note: 'two\nlines',
        isRecurring: false,
      ),
      ExpenseExportRow(
        date: LocalDate(2026, 10, 9),
        amount: const Money(120000),
        categoryName: 'Gym',
        walletName: 'Son',
        isRecurring: true,
      ),
      ExpenseExportRow(
        date: LocalDate(2026, 10, 10),
        amount: const Money(500000),
        categorySeedKey: 'salary',
        walletSeedKey: 'me',
        isRecurring: false,
        kind: TransactionKind.income,
      ),
      ExpenseExportRow(
        date: LocalDate(2026, 10, 11),
        amount: const Money(50000),
        isTransfer: true,
        walletSeedKey: 'me',
        toWalletName: 'Son',
        note: 'Pocket money',
        isRecurring: false,
      ),
    ];

    List<List<String>> records([Iterable<ExpenseExportRow>? only]) =>
        CsvExport.records(only ?? rows, CurrencyUtils.defaultCurrency, _label, _wallet);

    test('starts with the header, with Wallet and Transfer columns', () {
      expect(CsvExport.records([], CurrencyUtils.defaultCurrency, _label, _wallet), [CsvExport.header]);
      expect(CsvExport.header, [
        'Date',
        'Type',
        'Title',
        'Amount',
        'Currency',
        'Category',
        'Wallet',
        'Transfer',
        'Note',
        'Recurring',
      ]);
    });

    test('writes ISO dates, plain amounts, the currency code, the wallet, and Yes / No', () {
      expect(records()[1], [
        '2026-10-08',
        'expense',
        'Lunch, with "friends"',
        '12.50',
        'EGP',
        'FOOD',
        'seed:me',
        '',
        'two\nlines',
        'No',
      ]);
      expect(records()[2], ['2026-10-09', 'expense', '', '1200.00', 'EGP', 'Gym', 'Son', '', '', 'Yes']);
    });

    test('the Type column says income or expense, and amounts stay positive', () {
      expect(records().skip(1).map((r) => r[1]), ['expense', 'expense', 'income', 'transfer']);
      expect(records()[3], ['2026-10-10', 'income', '', '5000.00', 'EGP', 'SALARY', 'seed:me', '', '', 'No']);
    });

    test('a transfer is one row: type transfer, the source wallet, the target wallet, no category', () {
      expect(records()[4], [
        '2026-10-11',
        'transfer',
        '',
        '500.00',
        'EGP',
        '',
        'seed:me',
        'Son',
        'Pocket money',
        'No',
      ]);
      expect(records([rows.last]), hasLength(2), reason: 'the header and one row, not one per leg');
    });

    test('every record has one field per column', () {
      expect(records().map((r) => r.length), everyElement(CsvExport.header.length));
    });

    test('amounts have the currency fraction digits, no grouping, whatever the language', () {
      final kwd = CurrencyUtils.byCode('KWD')!;
      final records = CsvExport.records(
        [
          ExpenseExportRow(
            date: LocalDate(2026, 1, 2),
            amount: const Money(1234567),
            categorySeedKey: 'food',
            isRecurring: false,
          ),
        ],
        kwd,
        _label,
        _wallet,
      );

      expect(records[1][3], '1234.567');
      expect(records[1][4], 'KWD');
    });

    test('encodes to a file Excel can open: quoted where needed', () {
      final text = CsvExport.encode(records());

      expect(
        text,
        'Date,Type,Title,Amount,Currency,Category,Wallet,Transfer,Note,Recurring\r\n'
        '2026-10-08,expense,"Lunch, with ""friends""",12.50,EGP,FOOD,seed:me,,"two\nlines",No\r\n'
        '2026-10-09,expense,,1200.00,EGP,Gym,Son,,,Yes\r\n'
        '2026-10-10,income,,5000.00,EGP,SALARY,seed:me,,,No\r\n'
        '2026-10-11,transfer,,500.00,EGP,,seed:me,Son,Pocket money,No\r\n',
      );
    });
  });

  group('ExportExpensesCsv', () {
    late _MockRepository repository;
    late _MockSharer sharer;
    late ExportExpensesCsv export;

    setUp(() {
      repository = _MockRepository();
      sharer = _MockSharer();
      export = ExportExpensesCsv(repository, sharer, today: () => LocalDate(2026, 10, 9));
      when(
        () => sharer.share(
          fileName: any(named: 'fileName'),
          bytes: any(named: 'bytes'),
          mimeType: any(named: 'mimeType'),
        ),
      ).thenAnswer((_) async => const Right(unit));
    });

    test('shares masroofix_expenses_<date>.csv, UTF-8 with a BOM', () async {
      when(() => repository.loadExpenseExport()).thenAnswer(
        (_) async => Right([
          ExpenseExportRow(
            date: LocalDate(2026, 10, 8),
            amount: const Money(1250),
            title: 'قهوة',
            categorySeedKey: 'food',
            walletSeedKey: 'me',
            isRecurring: false,
          ),
        ]),
      );

      final result = await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label, walletLabel: _wallet);

      expect(result.isRight(), isTrue);
      final captured = verify(
        () => sharer.share(
          fileName: captureAny(named: 'fileName'),
          bytes: captureAny(named: 'bytes'),
          mimeType: captureAny(named: 'mimeType'),
        ),
      ).captured;
      expect(captured[0], 'masroofix_expenses_2026-10-09.csv');
      expect(captured[2], 'text/csv');
      final bytes = captured[1] as Uint8List;
      expect(bytes.take(3), CsvExport.bom);
      expect(utf8.decode(bytes.skip(3).toList()), contains('2026-10-08,expense,قهوة,12.50,EGP,FOOD,seed:me,,,No'));
    });

    test('a failed read is returned and nothing is shared', () async {
      when(() => repository.loadExpenseExport()).thenAnswer((_) async => const Left(Failure.storage(message: 'x')));

      final result = await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label, walletLabel: _wallet);

      expect(result, const Left<Failure, Unit>(Failure.storage(message: 'x')));
      verifyNever(
        () => sharer.share(
          fileName: any(named: 'fileName'),
          bytes: any(named: 'bytes'),
          mimeType: any(named: 'mimeType'),
        ),
      );
    });

    test('a failed share is returned for the snackbar', () async {
      when(() => repository.loadExpenseExport()).thenAnswer((_) async => const Right([]));
      when(
        () => sharer.share(
          fileName: any(named: 'fileName'),
          bytes: any(named: 'bytes'),
          mimeType: any(named: 'mimeType'),
        ),
      ).thenAnswer((_) async => const Left(Failure.exportFailed(message: 'no space')));

      final result = await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label, walletLabel: _wallet);

      expect(result.isLeft(), isTrue);
    });

    test('a large export is encoded off the UI isolate and comes out the same', () async {
      final many = [
        for (var i = 0; i < ExportExpensesCsv.isolateThreshold + 10; i++)
          ExpenseExportRow(
            date: LocalDate(2026, 10, 8),
            amount: Money(100 + i),
            title: 'Item $i',
            categorySeedKey: 'food',
            walletSeedKey: 'me',
            isRecurring: false,
          ),
      ];
      when(() => repository.loadExpenseExport()).thenAnswer((_) async => Right(many));

      await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label, walletLabel: _wallet);

      final bytes =
          verify(
                () => sharer.share(
                  fileName: any(named: 'fileName'),
                  bytes: captureAny(named: 'bytes'),
                  mimeType: any(named: 'mimeType'),
                ),
              ).captured.single
              as Uint8List;
      final lines = const LineSplitter().convert(utf8.decode(bytes.skip(3).toList()));
      expect(lines, hasLength(many.length + 1));
      expect(
        lines.last,
        '2026-10-08,expense,Item ${many.length - 1},${((100 + many.length - 1) / 100).toStringAsFixed(2)},EGP,FOOD,seed:me,,,No',
      );
    });
  });
}
