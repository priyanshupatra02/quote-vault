// import 'dart:ui' as ui;

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:quote_vault/core/router/router.gr.dart';
// import 'package:quote_vault/core/theme/app_colors.dart';
// import 'package:quote_vault/core/theme/text_styles.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Determine active index based on current route
//     final currentRoute = context.router.current.name;
//     final int activeIndex;

//     // Logic for 4-tab structure
//     if (currentRoute == DiscoverRoute.name) {
//       activeIndex = 0;
//     } else if (currentRoute == ExploreRoute.name) {
//       activeIndex = 1;
//     } else if (currentRoute == SavedRoute.name) {
//       activeIndex = 2;
//     } else if (currentRoute == SettingsRoute.name) {
//       activeIndex = 3;
//     } else {
//       activeIndex = 0; // Default
//     }

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor =
//         isDark ? AppColors.backgroundDark.withOpacity(0.9) : Colors.white.withOpacity(0.9);
//     final borderColor = isDark ? Colors.white12 : Colors.black.withOpacity(0.05);

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: bgColor,
//         border: Border(
//           top: BorderSide(
//             color: borderColor,
//             width: 1,
//           ),
//         ),
//       ),
//       child: ClipRect(
//         child: BackdropFilter(
//           filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
//           child: Padding(
//             padding: const EdgeInsets.only(top: 12.0, bottom: 24.0), // tailored padding
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BottomNavItem(
//                   icon: Icons.home,
//                   label: 'Home',
//                   isActive: activeIndex == 0,
//                   onTap: () {
//                     // Home -> DiscoverRoute
//                     if (currentRoute != DiscoverRoute.name) {
//                       context.router.replace(const DiscoverRoute());
//                     }
//                   },
//                 ),
//                 BottomNavItem(
//                   icon: Icons.explore,
//                   label: 'Explore',
//                   isActive: activeIndex == 1,
//                   onTap: () {
//                     // Explore -> ExploreRoute
//                     if (currentRoute != ExploreRoute.name) {
//                       context.router.replace(const ExploreRoute());
//                     }
//                   },
//                 ),
//                 BottomNavItem(
//                   icon: Icons.bookmarks,
//                   label:
//                       'Vault', // "Saved" or "Vault" per text. Design text says "Vault" in one place, "Saved" in another. "Vault" is distinct.
//                   isActive: activeIndex == 2,
//                   onTap: () {
//                     if (currentRoute != SavedRoute.name) {
//                       context.router.replace(const SavedRoute());
//                     }
//                   },
//                 ),
//                 BottomNavItem(
//                   icon: Icons.settings,
//                   label: 'Settings',
//                   isActive: activeIndex == 3,
//                   onTap: () {
//                     if (currentRoute != SettingsRoute.name) {
//                       context.router.replace(const SettingsRoute());
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BottomNavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;

//   const BottomNavItem({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final inactiveColor = isDark ? Colors.white60 : Colors.black45;

//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.opaque,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//             decoration: isActive
//                 ? BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(999),
//                   )
//                 : null,
//             child: Icon(
//               icon,
//               color: isActive ? AppColors.primary : inactiveColor,
//               size: 26,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: AppTextStyles.bottomNavText.copyWith(
//               color: isActive ? AppColors.primary : inactiveColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
