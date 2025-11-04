import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/app/widgets/timeline_item.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class ExperienceSection extends GetView<HomeController> {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 900),
      padding: EdgeInsets.fromLTRB(isWide ? 120 : 20, 80, isWide ? 80 : 20, 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgDark, const Color(0xFF0a0a0a), AppColors.bgDark],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Obx(() {
          final education = controller.educationItems;
          final work = controller.workExperience;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'EDUCATION & EXPERIENCE'),
              const SizedBox(height: 20),
              // Timeline View
              if (isMobile)
                _buildMobileTimeline(education, work)
              else
                _buildDesktopTimeline(education, work, isWide),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMobileTimeline(List education, List work) {
    final allItems = [...education, ...work]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Column(
      children: allItems.asMap().entries.map((entry) {
        return TimelineCard(
          experience: entry.value,
          index: entry.key,
          isLeft: false,
        );
      }).toList(),
    );
  }

  Widget _buildDesktopTimeline(List education, List work, bool isWide) {
    final allItems = [...education, ...work]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Stack(
      children: [
        // Center Line
        Positioned(
          left: isWide ? 0 : 0,
          right: isWide ? 0 : 0,
          child: Center(
            child: Container(
              width: 3,
              height: (allItems.length * 280).toDouble(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.themeColor.withOpacity(0.5),
                    AppColors.themeColor.withOpacity(0.1),
                    AppColors.themeColor.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Timeline Items
        Column(
          children: allItems.asMap().entries.map((entry) {
            final isLeft = entry.key % 2 == 0;
            return TimelineCard(
              experience: entry.value,
              index: entry.key,
              isLeft: isLeft,
            );
          }).toList(),
        ),
      ],
    );
  }
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
                    AppColors.themeColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.sectionDescription,
                  letterSpacing: 2,
                ),
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
                    AppColors.themeColor.withOpacity(0.3),
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
