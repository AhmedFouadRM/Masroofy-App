import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/process_due_recurring.dart';

/// Generates due recurring expenses on launch and on every resume from the
/// background (V1 has no background tasks). Lists update through their
/// database streams, so nothing else needs to be told.
class RecurringAutoGenerator extends StatefulWidget {
  const RecurringAutoGenerator({required this.processDue, required this.child, super.key});

  final ProcessDueRecurring processDue;
  final Widget child;

  @override
  State<RecurringAutoGenerator> createState() => _RecurringAutoGeneratorState();
}

class _RecurringAutoGeneratorState extends State<RecurringAutoGenerator> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _generate);
    _generate();
  }

  // A failure is retried on the next resume; generation is idempotent.
  void _generate() => unawaited(widget.processDue());

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
