import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.database({required String message}) = DatabaseFailure;
  const factory Failure.validation({required String message}) = ValidationFailure;
  const factory Failure.notFound({required String message}) = NotFoundFailure;
  const factory Failure.unexpected({required String message}) = UnexpectedFailure;
}
