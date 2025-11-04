import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home/controllers/home_controller.dart';
import '../theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Sidebar extends GetView<HomeController> {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1a1a1a), AppColors.cardBg],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Obx(() {
        final profile = controller.profile.value;

        return Column(
          children: [
            // Header Section
            _buildHeader(profile),

            const SizedBox(height: 8),

            // Divider with gradient
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.themeColor.withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: 'HOME',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'ABOUT ME',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: Icons.speed_rounded,
                    label: 'SKILLS',
                    index: 2,
                  ),
                  _buildNavItem(
                    icon: Icons.work_rounded,
                    label: 'EXPERIENCE',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.verified_rounded,
                    label: 'CERTIFICATIONS',
                    index: 4,
                  ),
                  _buildNavItem(
                    icon: Icons.star_rounded,
                    label: 'TESTIMONIALS',
                    index: 5,
                  ),
                  _buildNavItem(
                    icon: Icons.mail_rounded,
                    label: 'CONTACT',
                    index: 6,
                  ),
                ],
              ),
            ),

            // Footer with social links
            _buildFooter(profile),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(profile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        children: [
          // Profile Image with Glow Effect
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.themeColor.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.themeColor, width: 3),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.themeColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
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
          ),

          const SizedBox(height: 20),

          // Name with Animation
          Text(
            profile?.name.toUpperCase() ?? 'LOADING...',
            style: const TextStyle(
              color: AppColors.sectionDescription,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Tagline
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.themeColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              'DevOps Engineer',
              style: TextStyle(
                color: AppColors.themeColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.themeColor, AppColors.themeColor.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'D',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    final isActive = false, // Add logic to track active section
  }) {
    return _NavItem(
      icon: icon,
      label: label,
      isActive: isActive,
      onTap: () => controller.scrollToSection(index),
    );
  }

  Widget _buildFooter(profile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Column(
        children: [
          // Social Links
          if (profile?.socialLinks != null)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (profile!.socialLinks['linkedin'] != null)
                  _buildSocialButton(
                    icon: Icons.business,
                    url: profile.socialLinks['linkedin']!,
                    color: const Color(0xFF0077B5),
                  ),
                if (profile.socialLinks['github'] != null)
                  _buildSocialButton(
                    icon: Icons.code,
                    url: profile.socialLinks['github']!,
                    color: const Color(0xFF333333),
                  ),
                if (profile.socialLinks['twitter'] != null)
                  _buildSocialButton(
                    icon: Icons.alternate_email,
                    url: profile.socialLinks['twitter']!,
                    color: const Color(0xFF1DA1F2),
                  ),
                if (profile.socialLinks['whatsapp'] != null)
                  _buildSocialButton(
                    icon: Icons.chat,
                    url: profile.socialLinks['whatsapp']!,
                    color: const Color(0xFF25D366),
                  ),
              ],
            ),

          const SizedBox(height: 16),

          // Download CV Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add your CV download logic
                launchUrl(Uri.parse('https://your-cv-url.pdf'));
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text(
                'DOWNLOAD CV',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.themeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Copyright
          Text(
            '© 2025 Dharmik Nakrani',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

// Custom Navigation Item Widget with Animations
class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: widget.isActive || _isHovered
                  ? LinearGradient(
                      colors: [
                        AppColors.themeColor.withOpacity(0.2),
                        AppColors.themeColor.withOpacity(0.05),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isActive
                    ? AppColors.themeColor
                    : _isHovered
                    ? AppColors.themeColor.withOpacity(0.5)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icon with glow effect
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isActive || _isHovered
                        ? AppColors.themeColor.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isActive || _isHovered
                        ? AppColors.themeColor
                        : AppColors.sectionDescription.withOpacity(0.6),
                    size: 20,
                  ),
                ),

                const SizedBox(width: 16),

                // Label
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.isActive || _isHovered
                          ? AppColors.themeColor
                          : AppColors.sectionDescription.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: widget.isActive || _isHovered
                          ? FontWeight.w700
                          : FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // Active indicator
                if (widget.isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.themeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.themeColor.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
