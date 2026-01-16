import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart';

class FeaturedAuthorsSection extends ConsumerWidget {
  const FeaturedAuthorsSection({super.key});

  static const List<Map<String, String>> _authors = [
    {'initials': 'MA', 'name': 'Marcus\nAurelius', 'searchName': 'Marcus Aurelius'},
    {'initials': 'My', 'name': 'Maya\nAngelou', 'searchName': 'Maya Angelou'},
    {'initials': 'AE', 'name': 'Albert\nEinstein', 'searchName': 'Albert Einstein'},
    {'initials': 'Ru', 'name': 'Rumi', 'searchName': 'Rumi'},
    {'initials': 'OS', 'name': 'Oscar\nWilde', 'searchName': 'Oscar Wilde'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FEATURED AUTHORS',
                  style: AppTextStyles.sectionLabel.copyWith(
                    color: AppColors.kGrey500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Show all authors - for now, show a snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All authors coming soon!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View All',
                    style: AppTextStyles.linkText.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Authors list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.14,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _authors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final author = _authors[index];
                return AuthorAvatar(
                  initials: author['initials']!,
                  name: author['name']!,
                  onTap: () {
                    // Search for quotes by this author
                    ref.read(quotesProvider.notifier).search(author['searchName']!);
                    // Navigate to Discover page
                    context.router.navigate(const DiscoverRoute());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AuthorAvatar extends StatelessWidget {
  const AuthorAvatar({
    super.key,
    required this.initials,
    required this.name,
    this.onTap,
  });

  final String initials;
  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Avatar circle
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade50),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: AppTextStyles.authorInitials.copyWith(
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTextStyles.authorName.copyWith(
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
