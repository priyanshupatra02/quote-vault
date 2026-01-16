import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/features/explore/view/widgets/categories_section.dart';
import 'package:quote_vault/features/explore/view/widgets/explore_header.dart';
import 'package:quote_vault/features/explore/view/widgets/featured_authors_section.dart';
import 'package:quote_vault/shared/widget/backgrounds/animated_mesh_gradient.dart';

@RoutePage()
class ExplorePage extends ConsumerWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow gradient behind app bar
      body: Stack(
        children: [
          // Background Gradient
          const AnimatedMeshGradient(),

          // Glassmorphism Overlay (Optional, for better text legibility)
          // Container(
          //   color: Colors.white.withOpacity(0.3),
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          //     child: Container(color: Colors.transparent),
          //   ),
          // ),

          // Main Content
          CustomScrollView(
            slivers: [
              // Sticky Header with Title + Search
              const ExploreHeader(),

              // Featured Authors Section
              const FeaturedAuthorsSection(),

              // Categories Section
              const CategoriesSection(),

              // Bottom padding for navbar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }
}
