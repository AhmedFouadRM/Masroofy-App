import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/usecases/delete_category.dart';
import 'package:masroofy/features/categories/domain/usecases/save_category.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ICategoryRepository {}

class _MockSave extends Mock implements SaveCategory {}

class _MockDelete extends Mock implements DeleteCategory {}

final _epoch = DateTime.utc(2026, 10, 8);

CategorySummary _summary(int id, {String? seedKey, String? name, int expenses = 0}) => CategorySummary(
  category: Category(
    id: id,
    seedKey: seedKey,
    name: name,
    icon: 'pets',
    color: 0xFF000000,
    sortOrder: id,
    createdAt: _epoch,
    updatedAt: _epoch,
  ),
  expenseCount: expenses,
  recurringCount: 0,
);

void main() {
  late _MockRepository repository;
  late _MockSave save;
  late _MockDelete delete;

  setUpAll(() => registerFallbackValue(const CategoryDraft(name: '', icon: '', color: 0)));

  setUp(() {
    repository = _MockRepository();
    save = _MockSave();
    delete = _MockDelete();
  });

  group('CategoriesCubit', () {
    final food = _summary(1, seedKey: 'food');
    final gym = _summary(9, name: 'Gym', expenses: 12);

    blocTest<CategoriesCubit, CategoriesState>(
      'splits the watched list into defaults and custom',
      setUp: () => when(repository.watchSummaries).thenAnswer((_) => Stream.value(Right([food, gym]))),
      build: () => CategoriesCubit(repository, delete),
      act: (cubit) => cubit.load(),
      expect: () => [
        CategoriesState(status: CategoriesStatus.loaded, defaults: [food], custom: [gym]),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'emits a load failure',
      setUp: () => when(
        repository.watchSummaries,
      ).thenAnswer((_) => Stream.value(const Left(Failure.storage(message: 'disk')))),
      build: () => CategoriesCubit(repository, delete),
      act: (cubit) => cubit.load(),
      expect: () => [
        const CategoriesState(
          status: CategoriesStatus.failure,
          loadFailure: Failure.storage(message: 'disk'),
        ),
      ],
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'removes the row at once and restores it if the delete fails',
      setUp: () => when(() => delete(9)).thenAnswer((_) async => const Left(Failure.notFound())),
      build: () => CategoriesCubit(repository, delete),
      seed: () => CategoriesState(status: CategoriesStatus.loaded, defaults: [food], custom: [gym]),
      act: (cubit) => cubit.delete(9),
      expect: () => [
        CategoriesState(status: CategoriesStatus.loaded, defaults: [food]),
        CategoriesState(
          status: CategoriesStatus.loaded,
          defaults: [food],
          custom: [gym],
          actionFailure: const Failure.notFound(),
        ),
      ],
    );

    test('cancels the subscription on close', () async {
      final controller = StreamController<Either<Failure, List<CategorySummary>>>();
      when(repository.watchSummaries).thenAnswer((_) => controller.stream);
      final cubit = CategoriesCubit(repository, delete)..load();
      expect(controller.hasListener, isTrue);
      await cubit.close();
      expect(controller.hasListener, isFalse);
      await controller.close();
    });
  });

  group('CategoryFormCubit', () {
    CategoryFormCubit build({int? id}) => CategoryFormCubit(repository, save, delete, categoryId: id);

    blocTest<CategoryFormCubit, CategoryFormState>(
      'a new category is ready immediately and saves',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(10)),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..nameChanged('Gym')
          ..iconSelected('fitness_center');
        await cubit.save();
      },
      skip: 3,
      expect: () => [
        isA<CategoryFormState>().having((s) => s.status, 'status', CategoryFormStatus.saving),
        isA<CategoryFormState>()
            .having((s) => s.status, 'status', CategoryFormStatus.saved)
            .having((s) => s.id, 'id', 10),
      ],
      verify: (_) => verify(
        () => save(const CategoryDraft(name: 'Gym', icon: 'fitness_center', color: 0xFFF97316)),
      ).called(1),
    );

    blocTest<CategoryFormCubit, CategoryFormState>(
      'a duplicate name becomes a field error, cleared on typing',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer(
        (_) async => const Left(Failure.validation(field: 'name', reason: ValidationReason.duplicate)),
      ),
      build: build,
      seed: () => const CategoryFormState(icon: 'pets', color: 1, status: CategoryFormStatus.ready, name: 'Food'),
      act: (cubit) async {
        await cubit.save();
        cubit.nameChanged('Food 2');
      },
      expect: () => [
        isA<CategoryFormState>().having((s) => s.status, 'status', CategoryFormStatus.saving),
        isA<CategoryFormState>().having((s) => s.nameError, 'nameError', ValidationReason.duplicate),
        isA<CategoryFormState>().having((s) => s.nameError, 'nameError', isNull),
      ],
    );

    blocTest<CategoryFormCubit, CategoryFormState>(
      'editing loads the category and its usage',
      setUp: () =>
          when(() => repository.getSummary(9)).thenAnswer((_) async => Right(_summary(9, name: 'Gym', expenses: 12))),
      build: () => build(id: 9),
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<CategoryFormState>()
            .having((s) => s.status, 'status', CategoryFormStatus.ready)
            .having((s) => s.name, 'name', 'Gym')
            .having((s) => s.usage?.expenseCount, 'expenses', 12),
      ],
    );

    blocTest<CategoryFormCubit, CategoryFormState>(
      'refuses to edit a default category',
      setUp: () => when(() => repository.getSummary(1)).thenAnswer((_) async => Right(_summary(1, seedKey: 'food'))),
      build: () => build(id: 1),
      act: (cubit) => cubit.load(),
      expect: () => [isA<CategoryFormState>().having((s) => s.status, 'status', CategoryFormStatus.loadFailure)],
    );

    blocTest<CategoryFormCubit, CategoryFormState>(
      'deletes the edited category',
      setUp: () => when(() => delete(9)).thenAnswer((_) async => const Right(unit)),
      build: () => build(id: 9),
      seed: () => const CategoryFormState(icon: 'pets', color: 1, status: CategoryFormStatus.ready, id: 9, name: 'Gym'),
      act: (cubit) => cubit.delete(),
      expect: () => [
        isA<CategoryFormState>().having((s) => s.status, 'status', CategoryFormStatus.deleting),
        isA<CategoryFormState>().having((s) => s.status, 'status', CategoryFormStatus.deleted),
      ],
    );

    blocTest<CategoryFormCubit, CategoryFormState>(
      'cannot save an empty name',
      build: build,
      seed: () => const CategoryFormState(icon: 'pets', color: 1, status: CategoryFormStatus.ready, name: '  '),
      act: (cubit) => cubit.save(),
      expect: () => <CategoryFormState>[],
      verify: (_) => verifyNever(() => save(any(), id: any(named: 'id'))),
    );
  });
}
