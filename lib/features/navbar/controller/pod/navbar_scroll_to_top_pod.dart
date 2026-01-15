import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavbarScrollRequest {
  final int index;

  const NavbarScrollRequest({required this.index});
}

final navbarScrollToTopProvider = StateProvider<NavbarScrollRequest?>(
  (ref) => null,
  name: 'navbarScrollToTopProvider',
);
