// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:quote_vault/features/counter/view/counter_page.dart'
    deferred as _i1;
import 'package:quote_vault/features/discover/view/discover_page.dart' as _i2;

/// generated route for
/// [_i1.CounterPage]
class CounterRoute extends _i3.PageRouteInfo<void> {
  const CounterRoute({List<_i3.PageRouteInfo>? children})
      : super(CounterRoute.name, initialChildren: children);

  static const String name = 'CounterRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return _i3.DeferredWidget(_i1.loadLibrary, () => _i1.CounterPage());
    },
  );
}

/// generated route for
/// [_i2.DiscoverPage]
class DiscoverRoute extends _i3.PageRouteInfo<void> {
  const DiscoverRoute({List<_i3.PageRouteInfo>? children})
      : super(DiscoverRoute.name, initialChildren: children);

  static const String name = 'DiscoverRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.DiscoverPage();
    },
  );
}
