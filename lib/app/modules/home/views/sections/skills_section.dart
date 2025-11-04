import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/skill_card.dart';

class SkillsSection extends GetView<HomeController> {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        image: const DecorationImage(
          image: AssetImage('assets/img/services-bg.jpg'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
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
            _SectionTitle(title: 'SKILLS'),
            const SizedBox(height: 32),
            
            // Category Tabs
            Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.skillCategories.map((category) {
                  final isSelected = controller.selectedSkillCategory.value == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => controller.selectedSkillCategory.value = category,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      selectedColor: AppColors.themeColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.sectionDescription,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  );
                }).toList(),
              ),
            )),
            
            const SizedBox(height: 32),
            
            // Skills Grid
            Obx(() {
              final skills = controller.filteredSkills;
              
              if (skills.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No skills in this category yet'),
                  ),
                );
              }
              
              return LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900
                      ? 4
                      : constraints.maxWidth > 600
                          ? 3
                          : 2;
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: skills.length,
                    itemBuilder: (context, index) => SkillCard(skill: skills[index]),
                  );
                },
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
