import 'package:flutter/material.dart';
import 'package:quote_vault/core/theme/app_colors.dart';
import 'package:quote_vault/core/theme/text_styles.dart';

class FeaturedAuthorsList extends StatelessWidget {
  const FeaturedAuthorsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data with images for V2
    final authors = [
      _AuthorData(
          'M. Aurelius',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD0HSUFEQSqrKJOlAqu9Ogun4YDRG8yD0Su_Qmeugqboc34Lqf5rjU05jBrPVXlJUYXHZo763y5jsW4KH4WBrVlkFDzGPfu1d_2gRQTJRdocww1d5ebxhDScX1pe47GFL0SYFsr1-eEVn2C1gG1mEH0yxiYGDs9cAblWL7qO6CRekx7sV0vT-yH6Cx2vbspypQxEBp2phtxj3jb6wScDCML-1lVivPvVzn69jRljn4ZXRo1iZIAcFFcP86o_pbXfkv2_0zQ7Q1f4FQ',
          AppColors.primary),
      _AuthorData(
          'M. Angelou',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAjx9R9qdc_JwqmcbUEJjA6QV6K_3_k0R8I-rCxLeI5TZ9fFcJjLAHk6JB6GWVUoLfVFRD_WFiJfOEx1NYWzu2rNXdskFZ0pQ7yIcP2S2pvGQZrJrXiOABY3unAEx5dpUoXL-uXU1oTRePbyi5Ip-z06YbdfKNfvtRo7pCVk85WjsK8ZOC3i4VyuGC5rfPKw9r3JoY4UGWB0P_br15A86mVxnLZHGWip_nm1huknrSUP92osacxFFrqD5-XPEUQ9zJcdOPRa4xGyQo',
          Colors.pink),
      _AuthorData(
          'Steve Jobs',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQayLu-6mQaV6dPJst5VYNMC8MEHrKG-Q34i0goixF50KTNq1Z1ezKgcTPn_vqbH8fAUnZJplT5bTdHaa24h10D4bjrK5c2W3E1_3HxW8H0Py3_MCnKXW3CtGFaYZ2cM8Zrtd_6c-D0fBzbwdqgF5AvIaKAn934fuQ7lRn8QxKwcgs6EhIKX8AWKWfoIV9PiX-rPfRzMKbqY_LDRRoHu-AEj6TR5VqKCg2RC4bZSi1s9LoVo1VejCGl9Bqvuhj-qzlqIa2zgA01UM',
          Colors.blue),
      _AuthorData(
          'Seneca',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDoj0XcC4isnz6MdwBHAT5-bWEl-iNcDXdzTniIOXYz9qhpTSD4HnMEhmWMnnEiQlqBOcgGYg-blyho8uazsXC3tXVnQDOvEQ193eFcsq10ZsoCBw4ce5LHnyIzQwnbpCWIIiUfIGO9tCi-0U4DeZ63vCKTJzf8sMyvqWw-VcBWhIZSVQnEVWgLRRmo_PXARehQKOaw09RQb7e7nCZQXbkmUk4UrvU4u4Az1UCMwRYOGyU5TruH7ElrRn9tBw7cq8YKMnvW1OzoX4k',
          Colors.amber),
      _AuthorData(
          'Brené Brown',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABTYtRqIP0hwdZa20VcpLpXJDBHzjdWpsOyK8-I8m_NXoDptQ7fJnD74id6LoP4SKHI7_-A6rTmbP-eeoVg_yLufK2cDsDdxiB-ac5Ks9gXUMPaOu9AQaB5wJlTl6DmScf3LZN2NFTj97pPzjIbFzuMszVTmwaAgjdDqmKSHI040fC8Qsls22aX2TiAhPq01_xf9mJl94TvFye84YevPrvYDHzf8whUUAnuaHacb9Tl0z-tRm0FfQ6HPnYkZi68UHADJ97m2imSdo',
          Colors.green),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending Authors',
                style: AppTextStyles.display.copyWith(
                  fontSize: 20, // text-xl
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.015,
                  height: 1.25, // leading-tight
                ),
              ),
              // Arrow buttons removed for mobile ease or could be added back
              // Keeping it simple for now as per image logic often implying horizontal scroll
              Row(
                children: [
                  ArrowButton(icon: Icons.arrow_back, filled: false),
                  SizedBox(width: 8),
                  ArrowButton(icon: Icons.arrow_forward, filled: true),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: authors.length,
            separatorBuilder: (c, i) => const SizedBox(width: 16), // gap-4
            itemBuilder: (context, index) {
              final author = authors[index];
              return Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          author.color.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.backgroundDark,
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        author.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      author.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.display.copyWith(
                        fontSize: 12, // text-xs
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool filled;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.primary : Colors.transparent,
        border: filled ? null : Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: filled
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Icon(
        icon,
        size: 18,
        color: filled ? Colors.white : Colors.white60,
      ),
    );
  }
}

class _AuthorData {
  final String name;
  final String imageUrl;
  final Color color;

  _AuthorData(this.name, this.imageUrl, this.color);
}
