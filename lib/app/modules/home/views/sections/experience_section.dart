import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/timeline_item.dart';

class ExperienceSection extends GetView<HomeController> {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isWide ? 300 : 20,
        80,
        isWide ? 80 : 20,
        80,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'EDUCATION | EXPERIENCE'),
            const SizedBox(height: 32),
            
            Obx(() {
              final education = controller.educationItems;
              final work = controller.workExperience;
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Education
                  if (education.isNotEmpty) ...[
                    Text(
                      'Education',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ...education.map((exp) => TimelineItem(experience: exp)),
                    const SizedBox(height: 32),
                  ],
                  
                  // Work Experience
                  if (work.isNotEmpty) ...[
                    Text(
                      'Work Experience',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ...work.map((exp) => TimelineItem(experience: exp)),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.themeColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
