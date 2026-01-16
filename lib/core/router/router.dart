import 'package:auto_route/auto_route.dart';
import 'package:quote_vault/core/router/auth_guard.dart';
import 'package:quote_vault/core/router/router.gr.dart';

/// This class used for defined routes and paths na dother properties
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      page: NavbarRoute.page,
      path: '/',
      initial: true,
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: ExploreRoute.page,
      path: '/explore',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: SavedRoute.page,
      path: '/saved',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: DiscoverRoute.page,
      path: '/home',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: EditorRoute.page,
      path: '/editor',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: ForgotPasswordRoute.page,
      path: '/forgot-password',
    ),
    AutoRoute(
      page: SettingsRoute.page,
      path: '/settings',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: ResetPasswordSuccessRoute.page,
      path: '/reset-password-success',
      guards: [AuthGuard()],
    ),
    AutoRoute(
      page: SignUpRoute.page,
      path: '/signup',
    ),
  ];
}
