import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home/controllers/home_controller.dart';
import '../theme/app_colors.dart';

class MobileDrawer extends GetView<HomeController> {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.bgDark),
            child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.themeColor,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.profile.value?.name ?? 'Portfolio',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            )),
          ),
          _drawerItem(context, 'HOME', Icons.home, 0),
          _drawerItem(context, 'ABOUT ME', Icons.person, 1),
          _drawerItem(context, 'SKILLS', Icons.speed, 2),
          _drawerItem(context, 'CV', Icons.article, 3),
          _drawerItem(context, 'CERTIFICATIONS', Icons.verified, 4),
          _drawerItem(context, 'TESTIMONIALS', Icons.star, 5),
          _drawerItem(context, 'CONTACT ME', Icons.mail, 6),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String label, IconData icon, int index) {
    return ListTile(
      leading: Icon(icon, color: AppColors.themeColor),
      title: Text(label, style: const TextStyle(color: AppColors.sectionDescription)),
      onTap: () {
        Get.back();
        controller.scrollToSection(index);
      },
    );
  }
}
