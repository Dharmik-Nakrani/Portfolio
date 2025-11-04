import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/app/data/models/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class AboutSection extends GetView<HomeController> {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 900;
    
    return Obx(() {
      final profile = controller.profile.value;
      
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 800),
        padding: EdgeInsets.fromLTRB(
          isWide ? 120 : 20,
          80,
          isWide ? 80 : 20,
          80,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgDark,
              const Color(0xFF0a0a0a),
            ],
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile 
              ? _buildMobileLayout(profile)
              : _buildDesktopLayout(profile, isWide),
        ),
      );
    });
  }

  Widget _buildMobileLayout(profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ABOUT ME'),
        const SizedBox(height: 40),
        Center(child: _ProfileImageCard(imageUrl: profile?.profileImage)),
        const SizedBox(height: 40),
        _AboutContent(profile: profile),
        const SizedBox(height: 40),
        _QuickStats(),
        const SizedBox(height: 40),
        _ContactCards(profile: profile),
      ],
    );
  }

  Widget _buildDesktopLayout(profile, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'ABOUT ME'),
        const SizedBox(height: 60),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Profile Image
            Expanded(
              flex: 2,
              child: _ProfileImageCard(imageUrl: profile?.profileImage),
            ),
            
            SizedBox(width: isWide ? 60 : 40),
            
            // Right: Content
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutContent(profile: profile),
                  const SizedBox(height: 40),
                  _QuickStats(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        _ContactCards(profile: profile),
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

// Profile Image Card with hover effect
class _ProfileImageCard extends StatefulWidget {
  final String? imageUrl;
  
  const _ProfileImageCard({this.imageUrl});

  @override
  State<_ProfileImageCard> createState() => _ProfileImageCardState();
}

class _ProfileImageCardState extends State<_ProfileImageCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * value),
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? AppColors.themeColor.withValues(alpha: 0.4)
                    : AppColors.themeColor.withValues(alpha: 0.2),
                blurRadius: _isHovered ? 40 : 20,
                spreadRadius: _isHovered ? 10 : 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 1,
                  child: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                      ? Image.network(
                          widget.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
                ),
                
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Border
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.themeColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.themeColor.withValues(alpha: 0.2),
            AppColors.themeColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.person_rounded,
          size: 120,
          color: AppColors.themeColor,
        ),
      ),
    );
  }
}

// About Content
class _AboutContent extends StatelessWidget {
  final ProfileModel profile;
  
  const _AboutContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hi There! ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.sectionDescription,
                ),
              ),
              const Text(
                '👋',
                style: TextStyle(fontSize: 28),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            profile.aboutMe,
            style: TextStyle(
              fontSize: 16,
              height: 1.8,
              color: AppColors.sectionDescription.withValues(alpha: 0.9),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),
          
          // Key Highlights
          _buildHighlight(
            icon: Icons.rocket_launch_rounded,
            text: 'Building scalable cloud infrastructure',
          ),
          const SizedBox(height: 12),
          _buildHighlight(
            icon: Icons.code_rounded,
            text: 'Automating deployments with CI/CD',
          ),
          const SizedBox(height: 12),
          _buildHighlight(
            icon: Icons.speed_rounded,
            text: 'Optimizing performance and reliability',
          ),
        ],
      ),
    );
  }

  Widget _buildHighlight({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.themeColor.withValues(alpha: 0.2),
                AppColors.themeColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.themeColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.sectionDescription.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Quick Stats Cards
class _QuickStats extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Obx(() => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _StatCard(
            icon: Icons.work_history_rounded,
            value: '${controller.yearsOfExperience}+',
            label: 'Years Experience',
            gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          _StatCard(
            icon: Icons.folder_special_rounded,
            value: '${controller.totalProjects}+',
            label: 'Projects Completed',
            gradient: const [Color(0xFF11998e), Color(0xFF38ef7d)],
          ),
          _StatCard(
            icon: Icons.verified_rounded,
            value: '${controller.totalCertifications}',
            label: 'Certifications',
            gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
          ),
        ],
      )),
    );
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final List<Color> gradient;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: _isHovered
              ? LinearGradient(colors: widget.gradient)
              : null,
          color: _isHovered ? null : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.gradient[0].withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered
                    ? Colors.white.withValues(alpha: 0.2)
                    : widget.gradient[0].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: _isHovered ? Colors.white : widget.gradient[0],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isHovered ? Colors.white : AppColors.themeColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    color: _isHovered
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.sectionDescription.withValues(alpha: 0.7),
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

// Contact Cards
class _ContactCards extends StatelessWidget {
  final ProfileModel profile;
  
  const _ContactCards({required this.profile});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1400),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _ContactCard(
            icon: Icons.phone_rounded,
            title: 'Phone',
            value: profile.phone,
            onTap: () => launchUrl(Uri.parse('tel:${profile.phone}')),
            gradient: const [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          _ContactCard(
            icon: Icons.email_rounded,
            title: 'Email',
            value: profile.email,
            onTap: () => launchUrl(Uri.parse('mailto:${profile.email}')),
            gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
          ),
          _ContactCard(
            icon: Icons.location_on_rounded,
            title: 'Location',
            value: profile.location,
            gradient: const [Color(0xFF4facfe), Color(0xFF00f2fe)],
          ),
        ],
      ),
    );
  }
}

// Contact Card
class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final List<Color> gradient;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    required this.gradient,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
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
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: _isHovered
                ? LinearGradient(colors: widget.gradient)
                : null,
            color: _isHovered ? null : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered 
                  ? Colors.transparent 
                  : Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.gradient[0].withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _isHovered 
                      ? Colors.white.withValues(alpha: 0.2)
                      : widget.gradient[0].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : widget.gradient[0],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: _isHovered 
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: _isHovered ? Colors.white : AppColors.sectionDescription,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
