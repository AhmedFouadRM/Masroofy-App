import 'dart:async';

import 'package:drift/native.dart' show SqliteException;
// DriftRemoteException is the only way to unwrap errors from drift_flutter's isolate.
// ignore: experimental_member_use
import 'package:drift/remote.dart' show DriftRemoteException;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';

/// SQLITE_CONSTRAINT primary result code (UNIQUE, FOREIGN KEY, CHECK, ...).
const _sqliteConstraint = 19;

/// Maps a database error to a [Failure]. drift_flutter runs SQLite on a
/// background isolate, so errors may arrive wrapped in [DriftRemoteException].
Failure failureFromDbError(Object error, [StackTrace? stackTrace]) {
  final cause = error is DriftRemoteException ? error.remoteCause : error;
  if (cause is SqliteException) {
    return (cause.extendedResultCode & 0xff) == _sqliteConstraint
        ? Failure.constraint(message: cause.message)
        : Failure.storage(message: cause.message);
  }
  return Failure.unexpected(error: cause, stackTrace: stackTrace);
}

/// Runs a database call and returns its result or the mapped [Failure].
Future<Either<Failure, T>> guardDb<T>(Future<T> Function() run) async {
  try {
    return Right(await run());
  } on Object catch (error, stackTrace) {
    return Left(failureFromDbError(error, stackTrace));
  }
}

extension DbStreamGuard<T> on Stream<T> {
  /// Emits each value as [Right] and each error as [Left] without closing.
  Stream<Either<Failure, T>> guarded() => transform(
    StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(Right(data)),
      handleError: (error, stackTrace, sink) => sink.add(Left(failureFromDbError(error, stackTrace))),
    ),
  );
}
