import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
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
        note: 'two\nlines',
        isRecurring: false,
      ),
      ExpenseExportRow(
        date: LocalDate(2026, 10, 9),
        amount: const Money(120000),
        categoryName: 'Gym',
        isRecurring: true,
      ),
    ];

    test('starts with the header', () {
      expect(CsvExport.records([], CurrencyUtils.defaultCurrency, _label), [CsvExport.header]);
      expect(CsvExport.header, ['Date', 'Title', 'Amount', 'Currency', 'Category', 'Note', 'Recurring']);
    });

    test('writes ISO dates, plain amounts, the currency code, and Yes / No', () {
      final records = CsvExport.records(rows, CurrencyUtils.defaultCurrency, _label);

      expect(records[1], ['2026-10-08', 'Lunch, with "friends"', '12.50', 'EGP', 'FOOD', 'two\nlines', 'No']);
      expect(records[2], ['2026-10-09', '', '1200.00', 'EGP', 'Gym', '', 'Yes']);
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
      );

      expect(records[1][2], '1234.567');
      expect(records[1][3], 'KWD');
    });

    test('encodes to a file Excel can open: quoted where needed', () {
      final text = CsvExport.encode(CsvExport.records(rows, CurrencyUtils.defaultCurrency, _label));

      expect(
        text,
        'Date,Title,Amount,Currency,Category,Note,Recurring\r\n'
        '2026-10-08,"Lunch, with ""friends""",12.50,EGP,FOOD,"two\nlines",No\r\n'
        '2026-10-09,,1200.00,EGP,Gym,,Yes\r\n',
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

    test('shares masroofy_expenses_<date>.csv, UTF-8 with a BOM', () async {
      when(() => repository.loadExpenseExport()).thenAnswer(
        (_) async => Right([
          ExpenseExportRow(
            date: LocalDate(2026, 10, 8),
            amount: const Money(1250),
            title: 'قهوة',
            categorySeedKey: 'food',
            isRecurring: false,
          ),
        ]),
      );

      final result = await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label);

      expect(result.isRight(), isTrue);
      final captured = verify(
        () => sharer.share(
          fileName: captureAny(named: 'fileName'),
          bytes: captureAny(named: 'bytes'),
          mimeType: captureAny(named: 'mimeType'),
        ),
      ).captured;
      expect(captured[0], 'masroofy_expenses_2026-10-09.csv');
      expect(captured[2], 'text/csv');
      final bytes = captured[1] as Uint8List;
      expect(bytes.take(3), CsvExport.bom);
      expect(utf8.decode(bytes.skip(3).toList()), contains('2026-10-08,قهوة,12.50,EGP,FOOD,,No'));
    });

    test('a failed read is returned and nothing is shared', () async {
      when(() => repository.loadExpenseExport()).thenAnswer((_) async => const Left(Failure.storage(message: 'x')));

      final result = await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label);

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

      final result = await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label);

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
            isRecurring: false,
          ),
      ];
      when(() => repository.loadExpenseExport()).thenAnswer((_) async => Right(many));

      await export(currency: CurrencyUtils.defaultCurrency, categoryLabel: _label);

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
        '2026-10-08,Item ${many.length - 1},${((100 + many.length - 1) / 100).toStringAsFixed(2)},EGP,FOOD,,No',
      );
    });
  });
}
