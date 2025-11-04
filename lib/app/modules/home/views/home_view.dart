import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/app/modules/home/views/sections/projects_section.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../controllers/home_controller.dart';
import '../../../widgets/sidebar.dart';
import '../../../widgets/mobile_drawer.dart';
import '../../../widgets/back_to_top_button.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/experience_section.dart';
import 'sections/certification_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/contact_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1200;

    return Scaffold(
      appBar: isWide ? null : _buildMobileAppBar(),
      drawer: isWide ? null : const MobileDrawer(),
      body: Stack(
        children: [
          Row(
            children: [
              if (isWide) const Sidebar(),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ScrollablePositionedList.builder(
                    itemScrollController: controller.itemScrollController,
                    itemPositionsListener: controller.itemPositionsListener,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return _buildSection(index);
                    },
                  );
                }),
              ),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: BackToTopButton(onTap: controller.scrollToTop),
          ),
        ],
      ),
    );
  }

  AppBar _buildMobileAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Obx(() {
        final name = controller.profile.value?.name ?? 'Portfolio';
        return Text(name, style: const TextStyle(fontSize: 18));
      }),
      elevation: 0,
    );
  }

  Widget _buildSection(int index) {
    switch (index) {
      case 0:
        return const HeroSection();
      case 1:
        return const AboutSection();
      case 2:
        return const SkillsSection();
      case 3:
        return const ProjectsSection(); // NEW SECTION
      case 4:
        return const ExperienceSection();
      case 5:
        return const CertificationSection();
      case 6:
        return const TestimonialsSection();
      case 7:
        return const ContactSection();
      default:
        return const SizedBox.shrink();
    }
  }
}
