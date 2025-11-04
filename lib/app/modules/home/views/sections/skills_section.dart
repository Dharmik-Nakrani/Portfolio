import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/skill_card.dart';

class SkillsSection extends GetView<HomeController> {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 900),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0a0a0a),
            AppColors.bgDark,
            const Color(0xFF0a0a0a),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Background Pattern
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              isWide ? 120 : 20,
              80,
              isWide ? 80 : 20,
              80,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'TECHNICAL SKILLS'),
                  const SizedBox(height: 20),

                  // Category Tabs with animation
                  _CategoryTabs(),

                  const SizedBox(height: 40),

                  // Skills Grid
                  _SkillsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Grid Background
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.themeColor.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 50.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Section Header
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.themeColor,
                    AppColors.themeColor.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.sectionDescription,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Container(
              height: 3,
              width: 200 * value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.themeColor,
                    AppColors.themeColor.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Category Tabs with animation
class _CategoryTabs extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Obx(() {
      return isMobile ? _buildMobileTabs() : _buildDesktopTabs();
    });
  }

  Widget _buildDesktopTabs() {
    return Row(
      children: controller.skillCategories.map((category) {
        final isSelected = controller.selectedSkillCategory.value == category;
        return _CategoryTab(
          label: category,
          isSelected: isSelected,
          onTap: () => controller.selectedSkillCategory.value = category,
        );
      }).toList(),
    );
  }

  Widget _buildMobileTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.skillCategories.map((category) {
          final isSelected = controller.selectedSkillCategory.value == category;
          return _CategoryTab(
            label: category,
            isSelected: isSelected,
            onTap: () => controller.selectedSkillCategory.value = category,
          );
        }).toList(),
      ),
    );
  }
}

// Individual Category Tab
class _CategoryTab extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 12, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.isSelected || _isHovered
                ? LinearGradient(
                    colors: [
                      AppColors.themeColor,
                      AppColors.themeColor.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            color: widget.isSelected || _isHovered
                ? null
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.themeColor
                  : _isHovered
                  ? AppColors.themeColor.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.1),
              width: 2,
            ),
            boxShadow: widget.isSelected || _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.themeColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getCategoryIcon(widget.label),
                color: widget.isSelected || _isHovered
                    ? Colors.white
                    : AppColors.sectionDescription.withValues(alpha: 0.7),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected || _isHovered
                      ? Colors.white
                      : AppColors.sectionDescription.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.bold
                      : FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'DevOps':
        return Icons.cloud_outlined;
      case 'Monitoring':
        return Icons.bar_chart_rounded;
      case 'Tools':
        return Icons.build_rounded;
      case 'Database':
        return Icons.storage_rounded;
      case 'Programming':
        return Icons.code_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}

// Skills Grid with staggered animation
class _SkillsGrid extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final skills = controller.filteredSkills;

      if (skills.isEmpty) {
        return _buildEmptyState();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1000
              ? 4
              : constraints.maxWidth > 700
              ? 3
              : 2;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: GridView.builder(
              key: ValueKey(controller.selectedSkillCategory.value),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: 1,
              ),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: EnhancedSkillCard(skill: skills[index], index: index),
                );
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: AppColors.themeColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'No skills in this category yet',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.sectionDescription.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
