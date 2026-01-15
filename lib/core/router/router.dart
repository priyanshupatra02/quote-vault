import 'package:auto_route/auto_route.dart';
import 'package:quote_vault/core/router/router.gr.dart';

/// This class used for defined routes and paths na dother properties
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      page: ExploreRoute.page,
      path: '/explore',
    ),
    AutoRoute(
      page: SavedRoute.page,
      path: '/saved',
    ),
    AutoRoute(
      page: DiscoverRoute.page,
      path: '/home',
    ),
    AutoRoute(
      page: EditorRoute.page,
      path: '/editor',
    ),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
      initial: true,
    ),
    AutoRoute(
      page: ForgotPasswordRoute.page,
      path: '/forgot-password',
    ),
    AutoRoute(
      page: SettingsRoute.page,
      path: '/settings',
    ),
    AutoRoute(
      page: ResetPasswordSuccessRoute.page,
      path: '/reset-password-success',
    ),
    AutoRoute(
      page: SignUpRoute.page,
      path: '/signup',
    ),
  ];
}
