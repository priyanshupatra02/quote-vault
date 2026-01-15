import 'package:auto_route/auto_route.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // Check if user is logged in
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // User is logged in, continue navigation
      resolver.next(true);
    } else {
      // User is not logged in, redirect to login page
      // We use push to allow potentially going back if needed, but usually replace is better for guards.
      // However, since this is a guard, redirecting handles the stack.
      router.push(const LoginRoute());
      // Don't resolve the original navigation yet (effectively cancelling it until login)
      // Or in this case, we just redirect.
      // Actually standard pattern is:
      // resolver.redirect(const LoginRoute());
    }
  }
}
