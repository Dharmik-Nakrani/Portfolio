import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends GetView<HomeController> {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1200;
    
    return Obx(() {
      final profile = controller.profile.value;
      
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
              _SectionTitle(title: 'ABOUT ME'),
              const SizedBox(height: 24),
              
              // About text
              Text(
                profile?.aboutMe ?? 'Loading...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              
              const SizedBox(height: 32),
              
              // Contact Info Cards
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _InfoCard(
                    icon: Icons.phone,
                    title: 'Mobile Number',
                    value: profile?.phone ?? '',
                    onTap: () => launchUrl(Uri.parse('tel:${profile?.phone}')),
                  ),
                  _InfoCard(
                    icon: Icons.email,
                    title: 'Email',
                    value: profile?.email ?? '',
                    onTap: () => launchUrl(Uri.parse('mailto:${profile?.email}')),
                  ),
                  _InfoCard(
                    icon: Icons.location_on,
                    title: 'Location',
                    value: profile?.location ?? '',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.themeColor, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
