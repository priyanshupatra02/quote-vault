import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quote_vault/core/router/router.gr.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';
import 'package:quote_vault/features/quotes/controller/pod/quotes_pod.dart'; // Make sure this path is correct

class ExploreSearchBar extends ConsumerStatefulWidget {
  const ExploreSearchBar({super.key});

  @override
  ConsumerState<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends ConsumerState<ExploreSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  // Predefined search suggestions
  static const List<String> _allSuggestions = [
    'Love',
    'Life',
    'Motivation',
    'Success',
    'Happiness',
    'Wisdom',
    'Friendship',
    'Courage',
    'Hope',
    'Dreams',
    'Marcus Aurelius',
    'Maya Angelou',
    'Albert Einstein',
    'Rumi',
    'Oscar Wilde',
    'Buddha',
    'Confucius',
    'Lao Tzu',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _controller.text.isNotEmpty;
    });
  }

  void _onTextChange() {
    if (!mounted) return;
    final query = _controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = [];
        _showSuggestions = false;
      } else {
        _filteredSuggestions =
            _allSuggestions.where((s) => s.toLowerCase().contains(query)).take(5).toList();
        _showSuggestions = _focusNode.hasFocus && _filteredSuggestions.isNotEmpty;
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    _focusNode.unfocus();
    ref.read(quotesProvider.notifier).search(suggestion);
    context.router.navigate(const DiscoverRoute());
  }

  void _onSubmit(String query) {
    if (query.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _showSuggestions = false;
      });
      _focusNode.unfocus();
      ref.read(quotesProvider.notifier).search(query);
      context.router.navigate(const DiscoverRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            border: Theme.of(context).brightness == Brightness.dark
                ? Border.all(color: Colors.white.withOpacity(0.1))
                : null,
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: AppTextStyles.body(context).copyWith(
              color: AppColors.text(context),
            ),
            decoration: InputDecoration(
              hintText: 'Search keywords or authors...',
              hintStyle: AppTextStyles.searchHint(context).copyWith(
                color: AppColors.textSecondary(context),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.textSecondary(context),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onSubmitted: _onSubmit,
          ),
        ),

        // Suggestions Dropdown
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.surface(context),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _filteredSuggestions.map((suggestion) {
                  final isAuthor = suggestion.contains(' ');
                  return InkWell(
                    onTap: () => _onSuggestionTap(suggestion),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isAuthor ? Icons.person_outline : Icons.tag,
                            size: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              suggestion,
                              style: AppTextStyles.body(context).copyWith(
                                color: AppColors.text(context),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.north_west,
                            size: 14,
                            color: AppColors.textSecondary(context),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
