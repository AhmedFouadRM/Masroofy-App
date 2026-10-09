import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Hosts [routes] in a real [GoRouter], for screens that navigate with
/// `context.push` / `context.pop`. Pass it as `pumpApp`'s child; the app's
/// providers and theme sit above it.
class RouterHost extends StatefulWidget {
  const RouterHost({required this.routes, super.key});

  final List<RouteBase> routes;

  @override
  State<RouterHost> createState() => _RouterHostState();
}

class _RouterHostState extends State<RouterHost> {
  late final GoRouter _router = GoRouter(routes: widget.routes);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Router<Object>(
    routerDelegate: _router.routerDelegate,
    routeInformationParser: _router.routeInformationParser,
    routeInformationProvider: _router.routeInformationProvider,
  );
}
