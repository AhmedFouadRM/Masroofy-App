import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';

/// Reads the phone's SMS inbox. Needs the READ_SMS permission.
// ignore: one_member_abstracts
abstract interface class ISmsInbox {
  /// Messages received since [since], newest first.
  Future<Either<Failure, List<RawSms>>> read({required DateTime since});
}
