import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class VaultFilters extends StatefulWidget {
  const VaultFilters({super.key});

  @override
  State<VaultFilters> createState() => _VaultFiltersState();
}

class _VaultFiltersState extends State<VaultFilters> {
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF262033)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8), // rounded-lg
      ),
      child: Row(
        children: [
          _buildFilterOption('All'),
          _buildFilterOption('Favorites'),
          _buildFilterOption('Folders'),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    final isSelected = selectedFilter == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = label;
          });
        },
        child: Container(
          height: 32, // h-10 w padding adjustments
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                )
              : null,
          child: Text(
            label,
            style: AppTextStyles.display.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF9CA3AF)
                      : Colors.grey.shade600),
            ),
          ),
        ),
      ),
    );
  }
}
