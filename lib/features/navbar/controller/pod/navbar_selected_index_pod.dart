import 'package:flutter_riverpod/flutter_riverpod.dart';

final navbarSelectedIndexProvider = StateProvider<int>(
  (ref) => 0,
  name: "navbarSelectedIndexProvider",
);
