import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home/controllers/home_controller.dart';
import '../theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileDrawer extends GetView<HomeController> {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgDark,
      child: Obx(() {
        final profile = controller.profile.value;

        return Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.themeColor.withOpacity(0.1),
                    AppColors.bgDark,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.themeColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.themeColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child:
                          profile?.profileImage != null &&
                              profile!.profileImage.isNotEmpty
                          ? Image.network(
                              profile.profileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildAvatarFallback(profile.name);
                              },
                            )
                          : _buildAvatarFallback(profile?.name ?? 'DN'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    profile?.name ?? 'Portfolio',
                    style: const TextStyle(
                      color: AppColors.sectionDescription,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.themeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'DevOps Engineer',
                      style: TextStyle(
                        color: AppColors.themeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _drawerItem('HOME', Icons.home_rounded, 0),
                  _drawerItem('ABOUT ME', Icons.person_rounded, 1),
                  _drawerItem('SKILLS', Icons.speed_rounded, 2),
                  _drawerItem('EXPERIENCE', Icons.work_rounded, 3),
                  _drawerItem('CERTIFICATIONS', Icons.verified_rounded, 4),
                  _drawerItem('TESTIMONIALS', Icons.star_rounded, 5),
                  _drawerItem('CONTACT', Icons.mail_rounded, 6),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Social Links
                  if (profile?.socialLinks != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (profile!.socialLinks['linkedin'] != null)
                          _socialIconButton(
                            Icons.business,
                            profile.socialLinks['linkedin']!,
                          ),
                        if (profile.socialLinks['github'] != null)
                          _socialIconButton(
                            Icons.code,
                            profile.socialLinks['github']!,
                          ),
                        if (profile.socialLinks['twitter'] != null)
                          _socialIconButton(
                            Icons.alternate_email,
                            profile.socialLinks['twitter']!,
                          ),
                        if (profile.socialLinks['whatsapp'] != null)
                          _socialIconButton(
                            Icons.chat,
                            profile.socialLinks['whatsapp']!,
                          ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Download CV
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse('https://your-cv-url.pdf'));
                      },
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('DOWNLOAD CV'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.themeColor, AppColors.themeColor.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'D',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(String label, IconData icon, int index) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.themeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.themeColor, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.sectionDescription,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
      onTap: () {
        Get.back();
        controller.scrollToSection(index);
      },
    );
  }

  Widget _socialIconButton(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, color: AppColors.themeColor),
      onPressed: () => launchUrl(Uri.parse(url)),
    );
  }
}
