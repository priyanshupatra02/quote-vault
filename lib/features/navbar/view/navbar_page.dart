import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/features/discover/view/discover_page.dart';
import 'package:quote_vault/features/explore/view/explore_page.dart';
import 'package:quote_vault/features/navbar/controller/pod/navbar_scroll_to_top_pod.dart';
import 'package:quote_vault/features/navbar/controller/pod/navbar_selected_index_pod.dart';
import 'package:quote_vault/features/saved/view/saved_page.dart';
import 'package:quote_vault/features/settings/view/settings_page.dart';

@RoutePage()
class NavbarPage extends ConsumerStatefulWidget {
  const NavbarPage({super.key});

  @override
  ConsumerState<NavbarPage> createState() => _NavbarPageState();
}

class _NavbarPageState extends ConsumerState<NavbarPage> {
  final List<Widget> _screens = [
    const DiscoverPage(),
    const ExplorePage(),
    const SavedPage(),
    const SettingsPage(),
  ];

  Future<bool> _onWillPop() async {
    final currentIndex = ref.read(navbarSelectedIndexProvider);

    // If not on home page, navigate to home first
    if (currentIndex != 0) {
      ref.read(navbarSelectedIndexProvider.notifier).state = 0;
      return false;
    }

    // If on home page, show exit confirmation
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (result == true) {
      SystemNavigator.pop();
    }
    return false;
  }

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;

    _onWillPop().then((shouldPop) {
      if (shouldPop && mounted) {
        Navigator.of(context).maybePop(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navbarSelectedIndexState = ref.watch(navbarSelectedIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvokedWithResult,
      child: Scaffold(
        body: IndexedStack(
          index: navbarSelectedIndexState,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navbarSelectedIndexState,
          labelTextStyle: WidgetStateProperty.all(
            Theme.of(context).textTheme.bodySmall,
          ),
          indicatorColor: AppColors.primary.withOpacity(0.15),
          backgroundColor:
              isDark ? AppColors.backgroundDark.withOpacity(0.95) : Colors.white.withOpacity(0.95),
          surfaceTintColor: Colors.transparent,
          onDestinationSelected: (selectedIndex) {
            ref.read(navbarSelectedIndexProvider.notifier).state = selectedIndex;
            ref.read(navbarScrollToTopProvider.notifier).state =
                NavbarScrollRequest(index: selectedIndex);
          },
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: isDark ? Colors.white60 : Colors.black45,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: AppColors.primary,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
                color: isDark ? Colors.white60 : Colors.black45,
              ),
              selectedIcon: Icon(
                Icons.explore,
                color: AppColors.primary,
              ),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.bookmark_border,
                color: isDark ? Colors.white60 : Colors.black45,
              ),
              selectedIcon: Icon(
                Icons.bookmark,
                color: AppColors.primary,
              ),
              label: 'Vault',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: isDark ? Colors.white60 : Colors.black45,
              ),
              selectedIcon: Icon(
                Icons.settings,
                color: AppColors.primary,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
